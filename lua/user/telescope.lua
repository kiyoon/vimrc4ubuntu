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

local path_actions = require("telescope_insert_path")

telescope.setup({
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
			},
		},
	},
})

-- get git folder
local function get_git_dir()
	local git_dir = vim.fn.trim(vim.fn.system("git rev-parse --show-toplevel"))
	return git_dir
end

M = {}
M.live_grep_gitdir = function()
	local git_dir = get_git_dir()
	if git_dir == "" then
		require("telescope.builtin").live_grep()
	else
		require("telescope.builtin").live_grep({
			cwd = git_dir,
		})
	end
end

vim.keymap.set(
	{ "n" },
	"<leader>ff",
	"<cmd>lua require('telescope.builtin').find_files()<cr>",
	{ noremap = true, silent = true }
)
vim.keymap.set(
	{ "i" },
	"<C-t>",
	"<cmd>lua require('telescope.builtin').git_files()<cr>",
	{ noremap = true, silent = true }
)
vim.keymap.set(
	{ "n" },
	"<leader>fg",
	"<cmd>lua require('telescope.builtin').git_files()<cr>",
	{ noremap = true, silent = true }
)
vim.keymap.set(
	{ "n" },
	"<leader>fW",
	"<cmd>lua require('telescope.builtin').live_grep()<cr>",
	{ noremap = true, silent = true }
)
vim.keymap.set(
	{ "n" },
	"<leader>fw",
	"<cmd>lua require('user.telescope').live_grep_gitdir()<cr>",
	{ noremap = true, silent = true }
)
vim.keymap.set(
	{ "n" },
	"<leader>fr",
	"<cmd>lua require('telescope.builtin').oldfiles()<cr>",
	{ noremap = true, silent = true }
)
vim.keymap.set(
	{ "n" },
	"<leader>fb",
	"<cmd>lua require('telescope.builtin').buffers()<cr>",
	{ noremap = true, silent = true }
)
vim.keymap.set(
	{ "n" },
	"<leader>fh",
	"<cmd>lua require('telescope.builtin').help_tags()<cr>",
	{ noremap = true, silent = true }
)

return M
