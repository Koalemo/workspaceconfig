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

### Neovim (`config/nvim/`)






`init.lua` loads `config.lazy` (lazy.nvim bootstrap), `config.keymaps`,
`config.options`, `config.autocmds` — see `config/nvim/lua/config/keymaps.lua`
and `config/nvim/lua/plugins/` for the full list of custom keymaps and plugin
specs.











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

Two caveats from the scan: `install.sh:10` contains a typo (`sudp apt install`), and `install.sh` is partially aspirational — the xpra/tmux steps are comments only, so treat it as semi-manual. For the Neovim keymaps I'd need to read `config/nvim/lua/config/keymaps.lua`, which wasn't available in the index — if you want those enumerated, a Devin session could pull the full file contents.
# Install

```
cd path/to/workdpaceconfig/
./install.sh
```

Also, have a look into the file `install.sh` for manual installation instruction.

For ssh to be less annooying:
Add the following to ~/.ssh/rc on each new server:

```
#!/bin/bash

# Fix SSH auth socket location so agent forwarding works with tmux
if test "$SSH_AUTH_SOCK" ; then
  ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi

# And some magic make vanilla X11 forwarding work
if read proto cookie && [ -n "$DISPLAY" ]; then
  echo "add unix:${DISPLAY#localhost:} $proto $cookie" | xauth -q
fi
```

# Activate
Add to .bashrc:
```
pushd path/to/workspaceconfig
. sourceme/sourceme.sh
popd;
```


