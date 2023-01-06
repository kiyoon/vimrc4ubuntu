vim.api.nvim_create_autocmd({ "BufEnter", "BufNew" }, {
	pattern = { "*.ju.py", "*.md" },
	callback = function()
		local python_host = vim.g.python3_host_prog or "python3"
		vim.api.nvim_create_user_command(
			"JupyniumAttachServer",
			-- System python
			-- [[call system(']] .. python_host .. [[ -m jupynium --nvim_socket_path ' . v:servername . ' &')]],
			-- Conda
			[[call system('source ~/bin/miniconda3/bin/activate jupynium && jupynium --nvim_listen_addr ' . v:servername . ' &')]],
			{}
		)
		-- vim.keymap.set('n', '<space>py', '<cmd>JupyniumAttachServer<CR>', {noremap = true, silent = true})
	end,
})

-- Text objects
vim.api.nvim_create_autocmd({ "BufEnter", "BufNew" }, {
	pattern = { "*.ju.py" },
	callback = function()
		vim.keymap.set(
			{ "n", "x", "o" },
			"[j",
			"<cmd>lua require'jupynium-textobjects'.goto_previous_cell_separator()<cr>"
		)
		vim.keymap.set({ "n", "x", "o" }, "]j", "<cmd>lua require'jupynium-textobjects'.goto_next_cell_separator()<cr>")
		vim.keymap.set(
			{ "n", "x", "o" },
			"<space>c",
			"<cmd>lua require'jupynium-textobjects'.goto_current_cell_separator()<cr>"
		)
		vim.keymap.set({ "x", "o" }, "aj", "<cmd>lua require'jupynium-textobjects'.select_cell(true, false)<cr>")
		vim.keymap.set({ "x", "o" }, "ij", "<cmd>lua require'jupynium-textobjects'.select_cell(false, false)<cr>")
		vim.keymap.set({ "x", "o" }, "aJ", "<cmd>lua require'jupynium-textobjects'.select_cell(true, true)<cr>")
		vim.keymap.set({ "x", "o" }, "iJ", "<cmd>lua require'jupynium-textobjects'.select_cell(false, true)<cr>")
	end,
})
