# workspaceconfig

Modular development workspace configuration: shell environment, Neovim, tmux,
Wayland desktop (dwl/waybar/wlock), qutebrowser, and a pinned EDA toolchain.

## Install

```
cd path/to/workspaceconfig/
./install.sh
```

`install.sh` performs:
- `apt install python3-pip` + `pip3 install neovim-remote` (provides `nvr`)
- `apt install golang` + `go install github.com/daedaleanai/dbt@latest`
- `dbt sync` — fetches all pinned dependencies from `MODULE` into `DEPS/`
- creates `bin/` and symlinks `DEPS/ripgrep/rg` → `bin/rg`

See `install.sh` for manual steps (xpra, tmux builds).

## Activate

Add to `~/.bashrc`:

```
pushd path/to/workspaceconfig
. sourceme/sourceme.sh
popd
```

### Persistent TMUX sessions across SSH reconnects

Need persistent `$SSH_AUTH_SOCK` and xauth cookie.
They would usually change on reconnect.

Add to `~/.ssh/rc` on each server:

```bash
#!/bin/bash
if test "$SSH_AUTH_SOCK" ; then
  ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi
if read proto cookie && [ -n "$DISPLAY" ]; then
  echo "add unix:${DISPLAY#localhost:} $proto $cookie" | xauth -q
fi
```

Learn more:

**Stable `SSH_AUTH_SOCK` symlink for tmux**

- https://werat.dev/blog/happy-ssh-agent-forwarding/ and https://gist.github.com/martijnvermaat/8070533

> Use `ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock` pattern so that tmux's fixed `SSH_AUTH_SOCK` resUolves to the current socket after reconnect.


**`~/.ssh/rc` semantics — cookies via stdin, runs before the shell**

- The `sshd(8)` man page, in the `SSHRC` section (https://man.openbsd.org/sshd.8#SSHRC).

  > "If X11 forwarding is in use, it will receive the 'proto cookie' pair in its standard input (and DISPLAY in its environment). The script must call `xauth(1)` because sshd will not run xauth automatically to add X11 cookies."

**`unix:` display name rewrite**

- `xauth(1)` / `Xsecurity(7)` man pages document the `unix:N` vs `hostname:N` display-name distinction — the X server matches cookies by exact display name, so a cookie stored as `localhost:10.0` won't be found when clients connect via `unix:10.0`. (https://man.openbsd.org/xauth.1, https://www.x.org/releases/X11R7.7/doc/man/man7/Xsecurity.7.xhtml)

One caveat: the exact `${DISPLAY#localhost:}` rewrite is convention rather than mandated protocol — whether `unix:` is needed depends on how X clients inside tmux resolve `DISPLAY`. The OpenBSD sshd man page example does `xauth -q -i merge -` style handling differently across versions, so verify against your sshd version's SSHRC section.


## Provided tools

Pinned via `MODULE` (fetched into `DEPS/` by `dbt`):

| Dependency | Type | Purpose |
|---|---|---|
| neovim | binary tarball | editor (`v0.12.5`), added to PATH |
| ripgrep | binary tarball | `rg`, symlinked into `bin/` |
| verilator | git | HDL simulator; `VERILATOR_ROOT` set, `bin/` prepended to PATH |
| oss-cad-suite-build | tar.gz | FPGA/EDA toolchain bundle |
| OpenSTA | git | static timing analysis |
| OpenROAD-flow-scripts | git | RTL-to-GDS flow |
| sv2v | git | SystemVerilog→Verilog converter |
| dbt-rules | git | build rules for `dbt` |
| dwl + dwl-patches | git | Wayland compositor |
| wlock | git | Wayland screen locker |
| qutebrowser | git | keyboard-driven browser |
| tpm | git | tmux plugin manager |
| scripts | git | `shortcut-menus` dmenu/wmenu scripts added to PATH |




Repo config dirs (`config/`): `nvim/`, `tmux/` (incl. tmux-powerline),
`waybar/`, `qutebrowser/`, `fusesoc/`.

## External required tools

Not provisioned by this repo — must exist on the system:

- `bash`, `git`, `sed`
- `python3-pip` / `pip3` (installed by `install.sh`)
- `golang` / `go` (for `dbt`)
- `highlight` — used by `LESSOPEN` for syntax-highlighted `less`
- `tmux`, `nvim` runtime deps; `nvr` (neovim-remote) for the `h`/`v`/`t` aliases
- `dmenu` or `wmenu` (selected via `$XDG_SESSION_DESKTOP`)
- `vivado`, `verible-verilog-format`, Libero (`LIBERO_PATH`/`LIBERO_LIC_PATH`),
  `xauth` — optional; warn-only if missing
- License env vars expected: `LM_LICENSE_FILE`, `XILINXD_LICENSE_FILE`

## Environment variables set by `sourceme.sh`

- `VERILATOR_ROOT=$ROOT/DEPS/verilator`
- `TOOLS_PATH` (default `~/tools`), `GOPATH` (default `~/go`),
  `CARGOPATH` (default `~/.cargo`), `USRBIN` (default `/usr/bin`)
- `CONFIGROOT=$ROOT/config`, `XDG_CONFIG_HOME`, `XDG_DATA_HOME`,
  `NVIMCONFIG`, `TMUX_HOME`, `SCREENRC`
- `EDITOR=nvim`, `menu=dmenu|wmenu`, `WORKSPACE_SET=1`
- `HISTSIZE`/`HISTFILESIZE=10000000`, shared history via `PROMPT_COMMAND`
- `LESSOPEN` pipes through `highlight` (solarized-light)
- PATH prepends: `$VERILATOR_ROOT/bin`, `$CARGOPATH/bin`, `$ROOT/bin`,
  `$ROOT/DEPS/neovim/bin`, `$ROOT/DEPS/scripts/shortcut-menus`

## Aliases

| Alias | Expansion |
|---|---|
| `vim`, `vi`, `nvim` | `nvim` |
| `vimdiff` | `nvim -d` |
| `h` / `v` / `t` | `nvr -o` / `nvr -O` / `nvr --remote-tab` (only inside nvim terminal, when `$NVIM_LISTEN_ADDRESS` set) |
| `less` | `less -m -N -g -i -J --line-numbers --underline-special` |
| `more` | `less` |
| `tmux` | `tmux -f $CONFIGROOT/tmux/tmux.conf` |
| `qutebrowser` | `qutebrowser -C $CONFIGROOT/qutebrowser/config.py` |
| `vvfi` | `verible-verilog-format --inplace` |
| `vvmts` | `vivado -mode tcl -source ` |
| `vvmbs` | `vivado -mode batch -source ` |
| `libefire` / `libedone` / `libelic` | Libero license daemon start/stop/restart (only if `LIBERO_PATH`/`LIBERO_LIC_PATH` set) |




Bash line editing is set to vi mode (`set -o vi`).

## Custom keybindings

### tmux (`config/tmux/tmux.conf`)

| Binding | Action |
|---|---|
| `C-a` | prefix (replaces `C-b`) |
| `prefix C-a` | last window |
| `prefix l` / `prefix h` (repeatable) | swap window right/left |

Status line keys are vi-style; plugins: tpm, tmux-sensible,
`Koalemo/tmux-resurrect` (nvim/vim session strategy, pane contents captured),
tmux-powerline. Default terminal: `st-256color`.
`SSH_AUTH_SOCK` is forced to `~/.ssh/ssh_auth_sock` (see `~/.ssh/rc` above).


### qutebrowser (`config/qutebrowser/config.py`)

| Key | Mode | Action | Source |
|---|---|---|---|
| `a` | normal | Enter insert mode | custom |
| `K` / `J` | normal | Next / prev tab | custom [2](#21-1)  |
| `H` / `L` | normal | Back / forward | custom [3](#21-2)  |
| `Q` | normal | Close tab | custom [4](#21-3)  |
| `<Ctrl-n>` / `<Ctrl-p>` | command | Completion item next / prev | custom [5](#21-4)  |

All other qutebrowser bindings are upstream defaults (e.g. `o` open, `d` close tab, `gg`/`G` scroll, `f` hint-follow, `yy` yank URL, `i` insert mode, `:` command mode).

### Neovim (`config/nvim/`)

`init.lua` loads `config.lazy` (lazy.nvim bootstrap), `config.keymaps`,
`config.options`, `config.autocmds` — see `config/nvim/lua/config/keymaps.lua`
and `config/nvim/lua/plugins/` for the full list of custom keymaps and plugin
specs.

`mapleader = " "` (space) [1](#19-0)

#### Core config (nvim core, `keymaps.lua`)

| Key | Mode | Action | Source |
|---|---|---|---|
| `h` `j` `k` `l` | n | Move left/down/up/right | nvim core |
| `w` `b` `e` `ge` | n | Word motions | nvim core |
| `0` `^` `$` `gg` `G` `{` `}` `%` | n | Line/file/paragraph motions, matching bracket | nvim core |
| `f{x}` `t{x}` `;` `,` | n | Find/till char, repeat | nvim core |
| `*` `#` | n | Search word under cursor fwd/back | nvim core |
| `/` `?` | n | Search fwd / back | nvim core |
| `i` `a` `o` `O` `I` `A` | n | Enter insert mode variants (`o`/`O` overridden by your custom binds) | nvim core |
| `v` `V` `<C-v>` | n | Visual char / line / block | nvim core |
| `d` `c` `y` `p` `P` `x` | n | Delete / change / yank / paste | nvim core |
| `u` `<C-r>` `.` | n | Undo / redo / repeat last change | nvim core |
| `>>` `<<` `==` | n | Indent / dedent / autoindent line | nvim core |
| `zz` `zt` `zb` | n | Center / top / bottom cursor line | nvim core |
| `<C-f>` `<C-b>` | n | Page down / up (`<C-d>`/`<C-u>` overridden by your centered variants) | nvim core |
| `<C-w>w` `<C-w>v` `<C-w>s` `<C-w>q` `=` | n | Window cycle / vsplit / split / close / equalize | nvim core |
| `gt` `gT` | n | Next / prev tab | nvim core |
| `:marks`, `m{a-z}` `` `{a-z}` `` | n | Set / jump to mark | nvim core |
| `q{a-z}` `@a` `@@` | n | Record / play macro | nvim core |
| `<C-o>` `<C-i>` | n | Jump back / forward in jumplist | nvim core |
| `<C-g>` | n | Show file info | nvim core |
| `<C-\><C-n>` | t | Exit terminal mode | nvim core |
| `~` `gu{motion}` `gU{motion}` | n | Swap / lower / upper case | nvim core |
| `r{x}` `R` `s` `S` | n | Replace char / replace mode / substitute | nvim core |
| `J` / `K` | v | Move selection down/up | custom |
| `J` | n | Join lines, keep cursor | custom |
| `<C-d>` / `<C-u>` | n | Half-page down/up, centered | custom |
| `n` / `N` | n | Search match next/prev, centered + unfold | custom |
| `<leader>p` | x | Paste over selection without yanking | custom |
| `<leader>y` / `<leader>Y` | n, v / n | Yank / yank-line to system clipboard | custom |
| `<leader>d` | n, v | Delete to black-hole register | custom |
| `<leader>fmt` | n | LSP format | custom |
| `<C-k>` / `<C-j>` | n | Quickfix next / prev | custom |
| `<leader>k` / `<leader>j` | n | Loclist next / prev | custom |
| `[d` / `]d` | n | Prev / next diagnostic | custom |
| `<leader>e` | n | Diagnostic float | custom |
| `<leader>q` | n | Diagnostics to loclist toggle| custom |
| `<leader>cd` | n | `cd` to file's directory | custom |
| `<leader>bc` / `<leader>bd` | n | Close / force-close buffer | custom |
| `<leader>o` / `<leader>O` | n | Blank line below / above | custom |
| `<C-l>` / `<C-h>` | n | Widen / narrow split | custom |
| `<C-n>` / `<C-p>` | n | Grow / shrink split vertically | custom |
| `<` / `>` | x | Indent, keep selection | custom |
| `o` | n (netrw) | Open entry | custom|
#### LSP Keybinds (nvim core, `snacks.nvim`)


| Key | Mode | Action | Source |
|---|---|---|---|
| `gd` | n | LSP definitions (picker) | custom/snacks.nvim - overrides builtin local-declaration `gd` |
| `gD` | n | LSP declarations (picker) | custom/snacks.nvim |
| `gI` | n | LSP implementations (picker) | custom/snacks.nvim - overlaps builtin `gri` |
| `gy` | n | LSP type definitions (picker) | custom/snacks.nvim - overlaps builtin `grt` |
| `gai` | n | Incoming calls (call hierarchy) | custom/snacks.nvim |
| `gao` / `gaI` | n | Outgoing calls (call hierarchy) | custom/snacks.nvim|
| `<leader>ss` | n | LSP document symbols | custom/snacks.nvim |
| `<leader>sS` | n | LSP workspace symbols | custom/snacks.nvim |
| `<leader>fmt` | n | `vim.lsp.buf.format()` — format buffer | custom/keymaps.lua |
| `[d` / `]d` | n | Prev / next diagnostic | custom/keymaps.lua - shadows the 0.11 builtin pair |
| `<leader>e` | n | `vim.diagnostic.open_float()` — line diagnostics popup | custom/keymaps.lua |
| `<leader>q` | n | `vim.diagnostic.setloclist()` — buffer diagnostics to loclist | custom/keymaps.lua |
| `<C-k>` / `<C-j>` | n | Quickfix next / prev (used to walk grep/LSP results) | custom/keymaps.lua |

### Neovim 0.12 builtin LSP defaults (active whenever a server attaches — lua_ls, rust_analyzer, verible via mason [2](#29-1) )

| Key | Mode | Action | Source |
|---|---|---|---|
| `K` | n | Hover documentation (`vim.lsp.buf.hover`) | nvim core default |
| `grn` | n | Rename symbol | nvim core default |
| `grr` | n | List references (builtin picker/quickfix) | nvim core default |
| `gra` | n, v | Code actions | nvim core default |
| `gri` | n | Go to implementation | nvim core default |
| `grt` | n | Go to type definition | nvim core default |
| `gO` | n | Document symbol outline | nvim core default |
| `<C-s>` | i | Signature help | nvim core default |
| `<C-x><C-o>` | i | Omnifunc completion (when `omnifunc` set by lspconfig) | nvim core default |

## Duplication worth a README footnote

- `gr` (snacks) vs `grr` (builtin) — both "references", different UIs; same for `gI`/`gri` and `gy`/`grt`.
- `gd` is fully shadowed: builtin `gd` = "goto local declaration", now unreachable.
- `K` conflicts in visual mode: builtin `K` (keywordprg/hover) vs your `v`-mode `K` = move-selection-up in `keymaps.lua` — hover is unavailable while text is selected.
- Diagnostic navigation: `[d`/`]d` are defined identically by core and your config; harmless.
- No `on_attach`-style binds (`<leader>rn`, `<leader>ca`, `<leader>D`) exist in this config — renaming/actions go through `grn`/`gra` or snacks.

Wiki pages you might want to explore:
- [LSP, Mason and Linting (Koalemo/workspaceconfig)](/wiki/Koalemo/workspaceconfig#4.4.1)
- [Neovim Configuration (Koalemo/workspaceconfig)](/wiki/Koalemo/workspaceconfig#4)

### Citations

**File:** config/nvim/lua/plugins/snacks.lua (L124-135)
```lua
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
    { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    -- Other
```

**File:** config/nvim/lua/plugins/mason-lspconfig.lua (L1-15)
```lua
return {
  "mason-org/mason-lspconfig.nvim",
  opts = {
    ensure_installed = {
      "lua_ls",
      "rust_analyzer",
      "stylua",
      "verible",
    },
  },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  }
}
```

### snacks.nvim (`plugins/snacks.lua`)

| Key | Action | Source |
|---|---|---|
| `<leader><space>` | Smart find files | custom |
| `<leader>,` / `<leader>fb` | Buffers | custom |
| `<leader>/` / `<leader>sg` | Grep | custom |
| `<leader>:` / `<leader>sc` | Command history | custom |
| `<leader>sC` | Commands | custom |
| `<leader>n` | Notification history (defined twice; notifier wins) | custom |
| `<leader>e` | File explorer (`explorer` module disabled — likely dead) | custom [4](#19-3)  |
| `<leader>fc` | Find config file | custom |
| `<leader>ff` / `<leader>fo` | Find files | custom |
| `<leader>fg` | Git files | custom |
| `<leader>fp` | Projects | custom |
| `<leader>fr` | Recent | custom |
| `<leader>gb` | Git branches | custom |
| `<leader>gl` / `<leader>gL` / `<leader>gf` | Git log / log line / log file | custom |
| `<leader>gs` / `<leader>gS` | Status / stash | custom |
| `<leader>gd` | Diff hunks | custom |
| `<leader>gi` / `<leader>gI` | GitHub issues open / all | custom |
| `<leader>gp` / `<leader>gP` | GitHub PRs open / all | custom |
| `<leader>sb` | Buffer lines (declared twice) | custom |
| `<leader>sB` | Grep open buffers | custom |
| `<leader>sw` | Grep word/selection (n, x) | custom |
| `<leader>s"` / `<leader>s/` | Registers / search history | custom |
| `<leader>sa` | Autocmds | custom |
| `<leader>sd` / `<leader>sD` | Diagnostics / buffer diagnostics | custom |
| `<leader>sh` / `<leader>sH` | Help / highlights | custom |
| `<leader>si` | Icons | custom |
| `<leader>sj` / `<leader>sk` | Jumps / keymaps | custom |
| `<leader>sl` / `<leader>sq` | Loclist / quickfix | custom |
| `<leader>sm` / `<leader>sM` | Marks / man pages | custom |
| `<leader>sp` | Search plugin spec | custom |
| `<leader>sR` / `<leader>su` | Resume / undo history | custom |
| `<leader>uC` | Colorscheme picker | custom |
| `<leader>un` | Dismiss notifications | custom |
| `<leader>z` / `<leader>Z` | Zen / zoom | custom |
| `<leader>.` / `<leader>S` | Scratch / select scratch | custom |
| `<leader>bd` | `Snacks.bufdelete()` | custom |
| `<leader>cR` | Rename file | custom |
| `<leader>gB` | Git browse (n, v) | custom |
| `<leader>gg` | Lazygit | custom |
| `<leader>N` | Neovim news | custom |
| `<c-/>` / `<c-_>` | Toggle terminal | custom |
| `]]` / `[[` | Next / prev reference (n, t) | custom |
| `<cr>` `<c-v>` `<c-x>` `<Tab>` `q` etc. | Picker-internal navigation | plugin default |


### vim-floaterm (`plugins/floaterm.lua`)

| Key | Action | Source |
|---|---|---|
| `<leader>ftn` `ftk` `ftt` | New / kill / toggle | custom |
| `<leader>fh` / `<leader>fl` | Prev / next | custom |
| `<leader>fts` / `<leader>ftv` | Send line / send selection | custom |
| `<C-\><C-n>` | Exit terminal mode | Neovim builtin (not plugin) | [6](#19-5)

### vim-mundo (`plugins/vim-mundo.lua`)

| Key | Action | Source |
|---|---|---|
| `<leader>mt` | MundoToggle | custom [7](#19-6)  |
| `<cr>` `o` `d` `p` `j`/`k` `q` etc. | Inside Mundo window: revert/diff/preview/navigate/quit | plugin default |

### nvim-surround (`plugins.lua`)

| Key | Action | Source |
|---|---|---|
| `ys{motion}{char}`, `yss{char}` | Add surround | plugin default |
| `ds{char}` / `cs{old}{new}` | Delete / change surround | plugin default |
| `S{char}` | v-mode surround | plugin default |

Empty `setup({})` → all defaults [8](#19-7) .

### vim-gitgutter (`plugins.lua`)

| Key | Action | Source |
|---|---|---|
| `]c` / `[c` | Next / prev hunk | plugin default |
| `<leader>hp` `hs` `hu` `hS` `hU` | Preview / stage / undo hunk / buffer | plugin default |
| `ic` / `ac` | Hunk text objects | plugin default |

### vim-vinegar (`plugins.lua`)

| Key | Action | Source |
|---|---|---|
| `-` | Open netrw at file's dir / go up | plugin default |
| `~`, `.`, `gh`, `y.` | Home / dotfiles / hidden / yank path | plugin default |

### vim-fugitive (`plugins.lua`)

| Key | Action | Source |
|---|---|---|
| `s` `u` `=` `dd` `dv` `dh` `cc` `q` (in `:G` buffer) | Stage/unstage/diff/commit/close | plugin default (buffer-local) |
| `y<C-G>` | Yank object path | plugin default | [9](#19-8)

### nerdy.nvim (`plugins.lua`)

| Key | Action | Source |
|---|---|---|
| `<leader>ni` | Icon picker | plugin default — `add_default_keybindings = true`; lhs from upstream, verify locally [10](#19-9)  |


### render-markdown.nvim (`plugins/render-markdown.lua`)

| Key | Action | Source |
|---|---|---|
| `<leader>bt`| Toggle markdown rendering (buffer)| custom|


## Known conflicts

- `<leader>e`: diagnostic float (keymaps.lua) vs `Snacks.explorer` (disabled module anyway)
- `<leader>bd`: `:bdelete!` (keymaps.lua) vs `Snacks.bufdelete()` (snacks.lua)
- `<leader>n`: declared twice in snacks `keys` — notifier wins
- `[d`/`]d`: your custom mappings override the 0.11 builtin defaults — same behavior anyway
- gitgutter's `<leader>h*` shadowed if you add `<leader>h` binds later

Wiki pages you might want to explore:
- [Plugin Specifications (Koalemo/workspaceconfig)](/wiki/Koalemo/workspaceconfig#4.4)
- [Neovim Configuration (Koalemo/workspaceconfig)](/wiki/Koalemo/workspaceconfig#4)

### Citations

**File:** config/nvim/lua/config/keymaps.lua (L1-1)
```lua
vim.g.mapleader = " "
```

**File:** config/nvim/lua/config/options.lua (L45-47)
```lua
-- Don't lose selection when shifting sideways
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")
```

**File:** config/nvim/lua/config/autocmds.lua (L10-22)
```lua
vim.api.nvim_create_autocmd('filetype', {
  pattern = 'netrw',
  desc = 'Better mappings for netrw',
  callback = function()
    local bind = function(lhs, rhs)
      vim.keymap.set('n', lhs, rhs, {remap = true, buffer = true})
    end

    -- edit new file
    bind('o', '<cr>')

  end
})
```

**File:** config/nvim/lua/plugins/snacks.lua (L13-13)
```lua
      explorer = { enabled = false },
```

**File:** config/nvim/lua/plugins/snacks.lua (L69-168)
```lua
  keys = {
    -- Top Pickers & Explorer
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
    -- find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fo", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- gh
    { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
    { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
    { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
    { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
    { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    -- Other
    { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
    { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
  },
```

**File:** config/nvim/lua/plugins/floaterm.lua (L1-10)
```lua
return { 'voldikss/vim-floaterm',
  keys={
    {"<leader>ftn", ":FloatermNew<cr>"},
    {"<leader>ftk", ":FloatermKill<cr>"},
    {"<leader>ftt", ":FloatermToggle<cr>"},
    {"<leader>fh", ":FloatermPrev<cr>"},
    {"<leader>fl", ":FloatermNext<cr>"},
    {"<leader>fts", ":FloatermSend<cr>"},
    {"<leader>ftv", ":'<.'>FloatermSend<cr>"},
  },
```

**File:** config/nvim/lua/plugins/vim-mundo.lua (L3-5)
```lua
  keys = {
	  {"<leader>mt", ':MundoToggle<cr>', desc="Mundo Toggle"},
  },
```

**File:** config/nvim/lua/plugins/plugins.lua (L15-18)
```lua
  -- GitCommands
  {
    'tpope/vim-fugitive'
  },
```

**File:** config/nvim/lua/plugins/plugins.lua (L69-78)
```lua
  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },
```

**File:** config/nvim/lua/plugins/plugins.lua (L89-89)
```lua
      add_default_keybindings = true, -- Add default keybindings
```

**File:** config/nvim/lua/plugins/plugins.lua (L96-104)
```lua
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
```

**File:** config/nvim/lua/plugins/nvim-lint.lua (L33-40)
```lua
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
    callback = function()

      -- try_lint without arguments runs the linters defined in `linters_by_ft`
      -- for the current filetype
      require("lint").try_lint()
    end,
    })
```







## Layout

```
bin/        # symlinked/wrapped binaries (on PATH)
config/     # nvim, tmux, waybar, qutebrowser, fusesoc configs (XDG_CONFIG_HOME)
envs/main/  # vendored python virtualenv
sourceme/   # sourceme.sh + dbt-completion.sh
MODULE      # pinned dependency manifest (dbt)
DEPS/       # fetched dependencies (gitignored)
BUILD/      # build output (gitignored)
r``
```

# Install

```
cd path/to/workdpaceconfig/
./install.sh
```

Also, have a look into the file `install.sh` for manual installation instruction.

