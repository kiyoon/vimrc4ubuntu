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

local path_actions = require "telescope_insert_path"
local trouble = require "trouble.providers.telescope"

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
        ["<c-t>"] = trouble.open_with_trouble,
      },
      i = { ["<c-t>"] = trouble.open_with_trouble },
    },
  },
}

-- get git folder
local function get_git_dir()
  local git_dir = vim.fn.trim(vim.fn.system "git rev-parse --show-toplevel")
  return git_dir
end

local builtin = require "telescope.builtin"

M = {}
M.live_grep_gitdir = function()
  local git_dir = get_git_dir()
  if git_dir == "" then
    builtin.live_grep()
  else
    builtin.live_grep {
      cwd = git_dir,
    }
  end
end

M.grep_string_gitdir = function()
  local git_dir = get_git_dir()
  if git_dir == "" then
    builtin.grep_string()
  else
    builtin.grep_string {
      cwd = git_dir,
    }
  end
end

-- vim.keymap.set({ "n" }, "<leader>ff", builtin.find_files, { noremap = true, silent = true })
vim.keymap.set({ "i" }, "<C-t>", builtin.git_files, { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>ff", builtin.git_files, { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>fW", builtin.live_grep, { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>fw", M.live_grep_gitdir, { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>fiw", M.grep_string_gitdir, { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>fr", builtin.oldfiles, { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>fb", builtin.buffers, { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>fh", builtin.help_tags, { noremap = true, silent = true })

return M
