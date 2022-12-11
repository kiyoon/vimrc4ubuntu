local status_ok, illuminate = pcall(require, "illuminate")
if not status_ok then
  return
end

vim.g.Illuminate_ftblacklist = {'alpha', 'NvimTree'}
vim.api.nvim_set_keymap('n', '<space>n', '<cmd>lua require"illuminate".goto_next_reference{wrap=true}<cr>', {noremap=true})
vim.api.nvim_set_keymap('n', '<space>p', '<cmd>lua require"illuminate".goto_prev_reference{wrap=true}<cr>', {noremap=true})
vim.api.nvim_set_keymap('n', '<space>v', '<cmd>lua require"illuminate".textobj_select()<cr>', {noremap=true})

illuminate.configure {
  providers = {
    "lsp",
    "treesitter",
    "regex",
  },
  delay = 200,
  filetypes_denylist = {
    "dirvish",
    "fugitive",
    "alpha",
    "NvimTree",
    "packer",
    "neogitstatus",
    "Trouble",
    "lir",
    "Outline",
    "spectre_panel",
    "toggleterm",
    "DressingSelect",
    "TelescopePrompt",
  },
  filetypes_allowlist = {},
  modes_denylist = {},
  modes_allowlist = {},
  providers_regex_syntax_denylist = {},
  providers_regex_syntax_allowlist = {},
  under_cursor = true,
}
