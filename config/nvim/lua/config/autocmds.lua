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
  python        = "habamax",
  lua           = "desert",
  rust          = "retrobox",
  verilog       = "slate",
  systemverilog = "slate",
  markdown      = "peachpuff",
}
local default_scheme = "torte"   -- matches options.lua
local ns_cache = {}              -- scheme -> namespace id

local function scheme_ns(scheme)
  if ns_cache[scheme] then return ns_cache[scheme] end

  -- snapshot: apply scheme, copy all groups into a new namespace, restore
  local prev = vim.g.colors_name or default_scheme
  local ns = vim.api.nvim_create_namespace("ft_colors_" .. scheme)
  if pcall(vim.cmd.colorscheme, scheme) then
    for name, def in pairs(vim.api.nvim_get_hl(0, {})) do
      vim.api.nvim_set_hl(ns, name, def)
    end
  else
    vim.api.nvim_del_namespace(ns)
    ns = 0
  end
  pcall(vim.cmd.colorscheme, prev)
  ns_cache[scheme] = ns
  return ns
end

local function apply_win_scheme()
  local ft = vim.bo.filetype
  local scheme = ft_colors[ft] or default_scheme
  vim.api.nvim_win_set_hl_ns(0, scheme_ns(scheme))
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "FileType" }, {
  callback = apply_win_scheme,
})
