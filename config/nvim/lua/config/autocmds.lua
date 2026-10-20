-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

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

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python', 'rust', 'lua' },
  callback = function()
    vim.treesitter.start()                            -- Highlighting
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- Folding
    -- vim.wo.foldmethod = 'expr'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- Indentation
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'systemverilog', 'verilog' },
  callback = function()
    vim.treesitter.start()                            -- Highlighting
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- Indentation
  end,
})

-- trim trailing whitespaces
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

-- Per-filetype colorschemes via window highlight namespaces (Nvim 0.10+)
local ft_colors = {
  -- python        = "habamax",
  -- lua           = "darkblue",
  rust          = "darkblue",
  verilog       = "slate",
  systemverilog = "slate",
  markdown      = "habamax",
}
local default_scheme = "torte"   -- matches options.lua
local ns_full  = {}              -- scheme -> normal ns
local ns_muted = {}              -- scheme -> muted ns

-- gray-mix a "#rrggbb" color; t=0 → gray, t=1 → original
local function mute_color(hex, t)
  if type(hex) ~= "number" then return hex end
  local r = math.floor(hex / 65536) % 256
  local g = math.floor(hex / 256) % 256
  local b = hex % 256
  local lum = math.floor(0.299 * r + 0.587 * g + 0.114 * b)
  local mix = function(c) return math.floor(lum + (c - lum) * t + 0.5) end
  return mix(r) * 65536 + mix(g) * 256 + mix(b)
end

-- scale RGB by factor f (0 = black, 1 = unchanged) — keeps hue
local function dim_color(hex, f)
  if type(hex) ~= "number" then return hex end
  local r = math.floor(math.floor(hex / 65536) % 256 * f + 0.5)
  local g = math.floor(math.floor(hex / 256) % 256 * f + 0.5)
  local b = math.floor(hex % 256 * f + 0.5)
  return r * 65536 + g * 256 + b
end

local function build_ns(scheme)
  local full  = vim.api.nvim_create_namespace("ft_" .. scheme)
  local muted = vim.api.nvim_create_namespace("ft_" .. scheme .. "_muted")
  if pcall(vim.cmd.colorscheme, scheme) then
    for name, def in pairs(vim.api.nvim_get_hl(0, {})) do
      vim.api.nvim_set_hl(full, name, def)
      local m = vim.tbl_extend("force", {}, def)
      m.fg = mute_color(def.fg, 0.35)   -- 35% saturation for unfocused
      m.bg = dim_color(def.bg, 0.99)
      m.sp = mute_color(def.sp, 0.35)
      m.bold, m.italic, m.underline = false, false, false
      vim.api.nvim_set_hl(muted, name, m)
    end
  else
    vim.api.nvim_del_namespace(full)
    vim.api.nvim_del_namespace(muted)
    full, muted = 0, 0
  end
  ns_full[scheme], ns_muted[scheme] = full, muted
end

for _, s in pairs(ft_colors) do
  if not ns_full[s] then build_ns(s) end
end
build_ns(default_scheme)
pcall(vim.cmd.colorscheme, vim.g.colors_name or default_scheme) -- restore once

local function win_scheme()
  return ft_colors[vim.bo.filetype] or default_scheme
end

local function set_ns(ns)
  if ns ~= 0 then pcall(vim.api.nvim_win_set_hl_ns, 0, ns) end
end

-- focused: full scheme
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "FileType" }, {
  callback = function() set_ns(ns_full[win_scheme()]) end,
})
-- unfocused: muted version of the same scheme
vim.api.nvim_create_autocmd("WinLeave", {
  callback = function() set_ns(ns_muted[win_scheme()]) end,
})
