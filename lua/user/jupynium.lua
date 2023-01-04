vim.api.nvim_create_autocmd({ "BufEnter", "BufNew" }, {
	pattern = "*.ju.py",
	callback = function()
		local python_host = vim.g.python3_host_prog or "python3"
		vim.api.nvim_create_user_command(
			"JupyniumStartServer",
			-- System python
			-- [[call system(']] .. python_host .. [[ -m jupynium --nvim_socket_path ' . v:servername . ' &')]],
			-- Conda
			[[call system('source ~/bin/miniconda3/bin/activate jupynium && python -m jupynium --nvim_socket_path ' . v:servername . ' &')]],
			{}
		)
		-- vim.keymap.set('n', '<space>py', '<cmd>JupyniumStartServer<CR>', {noremap = true, silent = true})
	end,
})
