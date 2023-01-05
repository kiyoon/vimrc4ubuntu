local function starts_with(str, start)
	return str:sub(1, #start) == start
end

local function treesitter_selection_mode(info)
	-- * query_string: eg '@function.inner'
	-- * method: eg 'v' or 'o'
	--print(info['method'])		-- visual, operator-pending
	if starts_with(info["query_string"], "@function.") then
		return "V"
	end
	return "v"
end

local function treesitter_incwhitespaces(info)
	-- * query_string: eg '@function.inner'
	-- * selection_mode: eg 'charwise', 'linewise', 'blockwise'
	-- if starts_with(info['query_string'], '@function.') then
	--  return false
	-- elseif starts_with(info['query_string'], '@comment.') then
	--  return false
	-- end
	return false
end

require("nvim-treesitter.configs").setup({
	-- vim-matchup
	matchup = {
		enable = true, -- mandatory, false will disable the whole extension
	},

	indent = {
		enable = true,
	},

	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn", -- set to `false` to disable one of the mappings
			node_incremental = "<cr>",
			scope_incremental = "grc",
			node_decremental = ".",
		},
	},

	-- A list of parser names, or "all"
	ensure_installed = {
		"c",
		"lua",
		"rust",
		"python",
		"bash",
		"json",
		"yaml",
		"html",
		"css",
		"vim",
		"java",
		"javascript",
		"cpp",
		"toml",
		"dockerfile",
		"gitcommit",
		"git_rebase",
		"gitattributes",
		"cmake",
		"latex",
		"markdown",
		"php",
		-- "gitignore", "sql",  -- requires treesitter-CLI
	},

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	-- List of parsers to ignore installing (for "all")
	ignore_install = { "javascript" },

	---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
	-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

	highlight = {
		-- `false` will disable the whole extension
		enable = true,

		-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
		-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
		-- the name of the parser)
		-- list of language that will be disabled
		disable = { "c", "rust" },
		-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
		disable = function(lang, buf)
			local max_filesize = 100 * 1024 -- 100 KB
			local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
			if ok and stats and stats.size > max_filesize then
				return true
			end
		end,

		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		-- Kiyoon note: it enables additional highlighting such as `git commit`
		additional_vim_regex_highlighting = true,
	},

	rainbow = {
		enable = true,
		-- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
		extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
		max_file_lines = nil, -- Do not enable for files with more than n lines, int
		-- colors = {}, -- table of hex strings
		-- termcolors = {} -- table of colour name strings
	},

	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["am"] = "@function.outer",
				["im"] = "@function.inner",
				["al"] = "@class.outer",
				-- You can optionally set descriptions to the mappings (used in the desc parameter of
				-- nvim_buf_set_keymap) which plugins like which-key display
				["il"] = { query = "@class.inner", desc = "Select inner part of a class region" },
				["ab"] = "@block.outer",
				["ib"] = "@block.inner",
				["ad"] = "@conditional.outer",
				["id"] = "@conditional.inner",
				["ao"] = "@loop.outer",
				["io"] = "@loop.inner",
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@call.outer",
				["if"] = "@call.inner",
				--["ac"] = "@comment.outer",
				--["ic"] = "@comment.outer",
				--["afr"] = "@frame.outer",
				--["ifr"] = "@frame.inner",
				--["aat"] = "@attribute.outer",
				--["iat"] = "@attribute.inner",
				--["asc"] = "@scopename.inner",
				--["isc"] = "@scopename.inner",
				["as"] = "@statement.outer",
				["is"] = "@statement.outer",
			},
			-- You can choose the select mode (default is charwise 'v')
			--
			-- Can also be a function which gets passed a table with the keys
			-- * query_string: eg '@function.inner'
			-- * method: eg 'v' or 'o'
			-- and should return the mode ('v', 'V', or '<c-v>') or a table
			-- mapping query_strings to modes.
			selection_modes = treesitter_selection_mode,
			-- if you set this to `true` (default is `false`) then any textobject is
			-- extended to include preceding or succeeding whitespace. succeeding
			-- whitespace has priority in order to act similarly to eg the built-in
			-- `ap`.
			--
			-- can also be a function which gets passed a table with the keys
			-- * query_string: eg '@function.inner'
			-- * selection_mode: eg 'v'
			-- and should return true of false
			include_surrounding_whitespace = treesitter_incwhitespaces,
		},
		swap = {
			enable = true,
			swap_next = {
				[")m"] = "@function.outer",
				[")c"] = "@comment.outer",
				[")a"] = "@parameter.inner",
				[")b"] = "@block.outer",
				[")l"] = "@class.outer",
			},
			swap_previous = {
				["(m"] = "@function.outer",
				["(c"] = "@comment.outer",
				["(a"] = "@parameter.inner",
				["(b"] = "@block.outer",
				["(l"] = "@class.outer",
			},
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]f"] = "@call.outer",
				["]d"] = "@conditional.outer",
				["]o"] = "@loop.outer",
				["]s"] = "@statement.outer",
				["]a"] = "@parameter.outer",
				["]c"] = "@comment.outer",
				["]b"] = "@block.outer",
				["]l"] = { query = "@class.outer", desc = "next class start" },
				["]]m"] = "@function.inner",
				["]]f"] = "@call.inner",
				["]]d"] = "@conditional.inner",
				["]]o"] = "@loop.inner",
				["]]a"] = "@parameter.inner",
				["]]b"] = "@block.inner",
				["]]l"] = { query = "@class.inner", desc = "next class start" },
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]F"] = "@call.outer",
				["]D"] = "@conditional.outer",
				["]O"] = "@loop.outer",
				["]S"] = "@statement.outer",
				["]A"] = "@parameter.outer",
				["]C"] = "@comment.outer",
				["]B"] = "@block.outer",
				["]L"] = "@class.outer",
				["]]M"] = "@function.inner",
				["]]F"] = "@call.inner",
				["]]D"] = "@conditional.inner",
				["]]O"] = "@loop.inner",
				["]]A"] = "@parameter.inner",
				["]]B"] = "@block.inner",
				["]]L"] = "@class.inner",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[f"] = "@call.outer",
				["[d"] = "@conditional.outer",
				["[o"] = "@loop.outer",
				["[s"] = "@statement.outer",
				["[a"] = "@parameter.outer",
				["[c"] = "@comment.outer",
				["[b"] = "@block.outer",
				["[l"] = "@class.outer",
				["[[m"] = "@function.inner",
				["[[f"] = "@call.inner",
				["[[d"] = "@conditional.inner",
				["[[o"] = "@loop.inner",
				["[[a"] = "@parameter.inner",
				["[[b"] = "@block.inner",
				["[[l"] = "@class.inner",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[F"] = "@call.outer",
				["[D"] = "@conditional.outer",
				["[O"] = "@loop.outer",
				["[S"] = "@statement.outer",
				["[A"] = "@parameter.outer",
				["[C"] = "@comment.outer",
				["[B"] = "@block.outer",
				["[L"] = "@class.outer",
				["[[M"] = "@function.inner",
				["[[F"] = "@call.inner",
				["[[D"] = "@conditional.inner",
				["[[O"] = "@loop.inner",
				["[[A"] = "@parameter.inner",
				["[[B"] = "@block.inner",
				["[[L"] = "@class.inner",
			},
		},
		lsp_interop = {
			enable = true,
			floating_preview_opts = { border = "rounded" },
			peek_definition_code = {
				["<C-t>"] = "@function.outer",
				["<leader>df"] = "@function.outer",
				["<leader>dF"] = "@class.outer",
			},
		},
	},
})

require("iswap").setup({
	move_cursor = true,
})

require("treesj").setup({ use_default_keymaps = false })
vim.keymap.set("n", "<space>l", "<cmd>TSJSplit<CR>")
vim.keymap.set("n", "<space>h", "<cmd>TSJJoin<CR>")
vim.keymap.set("n", "<space>g", "<cmd>TSJToggle<CR>")

require("treesitter_indent_object").setup()
-- select context-aware indent
vim.keymap.set({ "x", "o" }, "ai", "<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_outer()<CR>")
-- ensure selecting entire line (or just use Vai)
vim.keymap.set({ "x", "o" }, "aI", "<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_outer(true)<CR>")
-- select inner block (only if block, only else block, etc.)
vim.keymap.set({ "x", "o" }, "ii", "<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_inner()<CR>")
-- select entire inner range (including if, else, etc.)
vim.keymap.set({ "x", "o" }, "iI", "<Cmd>lua require'treesitter_indent_object.textobj'.select_indent_inner(true)<CR>")


vim.cmd[[
" Treehopper
omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
xnoremap <silent> m :lua require('tsht').nodes()<CR>
nmap m <Cmd>lua require('tsht').move({ side = "start" })<CR>
nnoremap M m	" default m marking is now M

"ISwap
nmap ,s <Cmd>ISwap<CR>
nmap ,S <Cmd>ISwapNode<CR>
nmap ,,s <Cmd>ISwapWith<CR>
nmap ,,S <Cmd>ISwapNodeWith<CR>
nmap <space>. <Cmd>ISwapWithRight<CR>
nmap <space>, <Cmd>ISwapWithLeft<CR>
nmap <space><space>. <Cmd>ISwapNodeWithRight<CR>
nmap <space><space>, <Cmd>ISwapNodeWithLeft<CR>
]]
