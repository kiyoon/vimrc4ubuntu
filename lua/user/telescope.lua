-- local status_ok, project = pcall(require, "project_nvim")
-- if not status_ok then
--   return
-- end
-- project.setup({
--
--   -- detection_methods = { "lsp", "pattern" }, -- NOTE: lsp detection will get annoying with multiple langs in one project
--   detection_methods = { "pattern" },
--
--   -- patterns used to detect root dir, when **"pattern"** is in detection_methods
--   patterns = { ".git", "Makefile", "package.json" },
-- })

local tele_status_ok, telescope = pcall(require, "telescope")
if not tele_status_ok then
  return
end

-- telescope.load_extension('projects')

local path_actions = require('telescope_insert_path')

telescope.setup {
  defaults = {

    prompt_prefix = " ",
    selection_caret = " ",
    --path_display = { "smart" },
    --    file_ignore_patterns = { ".git/", "node_modules" },

    mappings = {
      n = {
        ["[i"] = path_actions.insert_reltobufpath_i_visual,
        ["[I"] = path_actions.insert_reltobufpath_I_visual,
        ["[a"] = path_actions.insert_reltobufpath_a_visual,
        ["[A"] = path_actions.insert_reltobufpath_A_visual,
        ["[o"] = path_actions.insert_reltobufpath_o_visual,
        ["[O"] = path_actions.insert_reltobufpath_O_visual,
        ["]i"] = path_actions.insert_abspath_i_visual,
        ["]I"] = path_actions.insert_abspath_I_visual,
        ["]a"] = path_actions.insert_abspath_a_visual,
        ["]A"] = path_actions.insert_abspath_A_visual,
        ["]o"] = path_actions.insert_abspath_o_visual,
        ["]O"] = path_actions.insert_abspath_O_visual,
        ["{i"] = path_actions.insert_reltobufpath_i_insert,
        ["{I"] = path_actions.insert_reltobufpath_I_insert,
        ["{a"] = path_actions.insert_reltobufpath_a_insert,
        ["{A"] = path_actions.insert_reltobufpath_A_insert,
        ["{o"] = path_actions.insert_reltobufpath_o_insert,
        ["{O"] = path_actions.insert_reltobufpath_O_insert,
        ["}i"] = path_actions.insert_abspath_i_insert,
        ["}I"] = path_actions.insert_abspath_I_insert,
        ["}a"] = path_actions.insert_abspath_a_insert,
        ["}A"] = path_actions.insert_abspath_A_insert,
        ["}o"] = path_actions.insert_abspath_o_insert,
        ["}O"] = path_actions.insert_abspath_O_insert,
        ["-i"] = path_actions.insert_reltobufpath_i_normal,
        ["-I"] = path_actions.insert_reltobufpath_I_normal,
        ["-a"] = path_actions.insert_reltobufpath_a_normal,
        ["-A"] = path_actions.insert_reltobufpath_A_normal,
        ["-o"] = path_actions.insert_reltobufpath_o_normal,
        ["-O"] = path_actions.insert_reltobufpath_O_normal,
        ["=i"] = path_actions.insert_abspath_i_normal,
        ["=I"] = path_actions.insert_abspath_I_normal,
        ["=a"] = path_actions.insert_abspath_a_normal,
        ["=A"] = path_actions.insert_abspath_A_normal,
        ["=o"] = path_actions.insert_abspath_o_normal,
        ["=O"] = path_actions.insert_abspath_O_normal,
      }
    },
  },
}
