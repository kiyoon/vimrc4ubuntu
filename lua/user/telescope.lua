local status_ok, project = pcall(require, "project_nvim")
if not status_ok then
  return
end
project.setup({

  -- detection_methods = { "lsp", "pattern" }, -- NOTE: lsp detection will get annoying with multiple langs in one project
  detection_methods = { "pattern" },

  -- patterns used to detect root dir, when **"pattern"** is in detection_methods
  patterns = { ".git", "Makefile", "package.json" },
})

local tele_status_ok, telescope = pcall(require, "telescope")
if not tele_status_ok then
  return
end

telescope.load_extension('projects')

local path_actions = require('telescope_insert_path')

telescope.setup {
  defaults = {

    prompt_prefix = " ",
    selection_caret = " ",
    --path_display = { "smart" },
    --    file_ignore_patterns = { ".git/", "node_modules" },

    mappings = {
      n = {
        ["pi"] = path_actions.insert_relpath_i_visual,
        ["pI"] = path_actions.insert_relpath_I_visual,
        ["pa"] = path_actions.insert_relpath_a_visual,
        ["pA"] = path_actions.insert_relpath_A_visual,
        ["po"] = path_actions.insert_relpath_o_visual,
        ["pO"] = path_actions.insert_relpath_O_visual,
        ["Pi"] = path_actions.insert_abspath_i_visual,
        ["PI"] = path_actions.insert_abspath_I_visual,
        ["Pa"] = path_actions.insert_abspath_a_visual,
        ["PA"] = path_actions.insert_abspath_A_visual,
        ["Po"] = path_actions.insert_abspath_o_visual,
        ["PO"] = path_actions.insert_abspath_O_visual,
        ["<space>pi"] = path_actions.insert_relpath_i_insert,
        ["<space>pI"] = path_actions.insert_relpath_I_insert,
        ["<space>pa"] = path_actions.insert_relpath_a_insert,
        ["<space>pA"] = path_actions.insert_relpath_A_insert,
        ["<space>po"] = path_actions.insert_relpath_o_insert,
        ["<space>pO"] = path_actions.insert_relpath_O_insert,
        ["<space>Pi"] = path_actions.insert_abspath_i_insert,
        ["<space>PI"] = path_actions.insert_abspath_I_insert,
        ["<space>Pa"] = path_actions.insert_abspath_a_insert,
        ["<space>PA"] = path_actions.insert_abspath_A_insert,
        ["<space>Po"] = path_actions.insert_abspath_o_insert,
        ["<space>PO"] = path_actions.insert_abspath_O_insert,
        ["<leader>pi"] = path_actions.insert_relpath_i_normal,
        ["<leader>pI"] = path_actions.insert_relpath_I_normal,
        ["<leader>pa"] = path_actions.insert_relpath_a_normal,
        ["<leader>pA"] = path_actions.insert_relpath_A_normal,
        ["<leader>po"] = path_actions.insert_relpath_o_normal,
        ["<leader>pO"] = path_actions.insert_relpath_O_normal,
        ["<leader>Pi"] = path_actions.insert_abspath_i_normal,
        ["<leader>PI"] = path_actions.insert_abspath_I_normal,
        ["<leader>Pa"] = path_actions.insert_abspath_a_normal,
        ["<leader>PA"] = path_actions.insert_abspath_A_normal,
        ["<leader>Po"] = path_actions.insert_abspath_o_normal,
        ["<leader>PO"] = path_actions.insert_abspath_O_normal,
      }
    },
  },
}
