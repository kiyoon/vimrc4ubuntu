" Automatic installation of vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

" Plugin install at once but activate conditionally
function! Cond(Cond, ...)
  let opts = get(a:000, 0, {})
  return a:Cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin()

Plug 'kiyoon/tmuxsend.vim'
Plug 'christoomey/vim-tmux-navigator'

Plug 'svermeulen/vim-subversive'
" s for substitute
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)
xmap s <plug>(SubversiveSubstitute)
" <space>siwie to substitute word from entire buffer
" <space>siwip to substitute word from paragraph
" <space>siwif to substitute word from function 
" <space>siwic to substitute word from class
" <space>ssip to substitute word from paragraph
nmap <space>s <plug>(SubversiveSubstituteRange)
xmap <space>s <plug>(SubversiveSubstituteRange)
nmap <space>ss <plug>(SubversiveSubstitute\ordRange)

" Scroll through paste by C-n C-p
" Change the default buffer by [y ]y
" :Yanks to see the yank history
" :ClearYanks to clear the yank history
Plug 'svermeulen/vim-yoink'
nmap <c-n> <plug>(YoinkPostPasteSwapBack)
nmap <c-p> <plug>(YoinkPostPasteSwapForward)
nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)
"nmap gp <plug>(YoinkPaste_gp)
nmap gP <plug>(YoinkPaste_gP)
nmap [y <plug>(YoinkRotateBack)
nmap ]y <plug>(YoinkRotateForward)
nmap y <plug>(YoinkYankPreserveCursorPosition)
xmap y <plug>(YoinkYankPreserveCursorPosition)
nmap <c-=> <plug>(YoinkPostPasteToggleFormat)

Plug 'tpope/vim-surround'
"Plug 'tpope/vim-fugitive'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-line'		" vil, val to select line
Plug 'kana/vim-textobj-entire'	    " vie, vae to select entire buffer (file)
Plug 'kana/vim-textobj-fold'		" viz, vaz to select fold
Plug 'kana/vim-textobj-indent'		" vii, vai, viI, vaI to select indent

"Plug 'vim-python/python-syntax'
"let g:python_highlight_all = 1

Plug 'chaoren/vim-wordmotion'
let g:wordmotion_prefix = ','

" use normal easymotion when in VIM mode
Plug 'easymotion/vim-easymotion', Cond(!exists('g:vscode'))
" use VSCode easymotion when in VSCode mode
Plug 'asvetliakov/vim-easymotion', Cond(exists('g:vscode'), { 'as': 'vsc-easymotion' })
" Use uppercase target labels and type as a lower case
"let g:EasyMotion_use_upper = 1
 " type `l` and match `l`&`L`
let g:EasyMotion_smartcase = 1
" Smartsign (type `3` and match `3`&`#`)
let g:EasyMotion_use_smartsign_us = 1

" \f{char} to move to {char}
" within line
map  <space>f <Plug>(easymotion-bd-fl)
map  <space>t <Plug>(easymotion-bd-tl)
map  <space>w <Plug>(easymotion-bd-wl)
map  <space>e <Plug>(easymotion-bd-el)
"nmap <Leader>f <Plug>(easymotion-overwin-f)

" <space>v{char}{char} to move to {char}{char}
" anywhere, even across windows
map  <space>v <Plug>(easymotion-bd-f2)
nmap <space>v <Plug>(easymotion-overwin-f2)

if !exists('g:vscode')
	"Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'neoclide/coc.nvim', {'tag': 'v0.0.81'}
	" (Default binding) Use <C-e> and <C-y> to cancel and confirm completion
	" I personally use <C-n> <C-p> to confirm completion without closing the popup.
	"
	" Toggle CoC diagnostics
	"nnoremap <silent> <F6> :call CocActionAsync('diagnosticToggle')<CR>
	" Show CoC diagnostics window
	nnoremap <silent> <F6> :CocDiagnostics<CR>
	" navigate diagnostics
	nmap <silent> <M-j> <Plug>(coc-diagnostic-next)
	nmap <silent> <M-k> <Plug>(coc-diagnostic-prev)
	" Use <c-space> to trigger completion.
	if has('nvim')
		inoremap <silent><expr> <c-space> coc#refresh()
	else
		inoremap <silent><expr> <c-@> coc#refresh()
	endif
	" Remap keys for gotos
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)
	au filetype python nmap <C-i> :CocCommand pyright.organizeimports<CR>
	nmap <space>rn <Plug>(coc-rename)
	

	"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	"Plug 'junegunn/fzf.vim'

	Plug 'github/copilot.vim'
else
	" tpope/vim-commentary behaviour for VSCode-neovim
	xmap gc  <Plug>VSCodeCommentary
	nmap gc  <Plug>VSCodeCommentary
	omap gc  <Plug>VSCodeCommentary
	nmap gcc <Plug>VSCodeCommentaryLine
endif

if has("nvim")
	if !exists('g:vscode')
		Plug 'numToStr/Comment.nvim'
	endif
	Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
	Plug 'EdenEast/nightfox.nvim'
	Plug 'nvim-lualine/lualine.nvim'

	Plug 'nvim-lua/plenary.nvim'
	Plug 'sindrets/diffview.nvim'
	nnoremap <leader>dv :DiffviewOpen<CR>
	nnoremap <leader>dc :DiffviewClose<CR>

	Plug 'smjonas/inc-rename.nvim'

lua << EOF
	vim.keymap.set("n", "<leader>rn", function()
	  return ":IncRename " .. vim.fn.expand("<cword>")
	end, { expr = true })
EOF

	Plug 'lewis6991/gitsigns.nvim'

	Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons
	Plug 'nvim-tree/nvim-tree.lua'
	nnoremap <leader>nt :NvimTreeToggle<CR>
	nnoremap <leader>nr :NvimTreeRefresh<CR>
	nnoremap <leader>nf :NvimTreeFindFile<CR>

	Plug 'lukas-reineke/indent-blankline.nvim'

	" Better syntax highlighting
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'nvim-treesitter/nvim-treesitter-textobjects'

	Plug 'neovim/nvim-lspconfig'

	Plug 'goolord/alpha-nvim'
	Plug 'lewis6991/impatient.nvim'
	Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
	" Find files using Telescope command-line sugar.
	nnoremap <leader>ff <cmd>Telescope find_files<cr>
	nnoremap <leader>fg <cmd>Telescope live_grep<cr>
	nnoremap <leader>fb <cmd>Telescope buffers<cr>
	nnoremap <leader>fh <cmd>Telescope help_tags<cr>

	" Wilder.nvim
	function! UpdateRemotePlugins(...)
		" Needed to refresh runtime files
		let &rtp=&rtp
		UpdateRemotePlugins
	endfunction

	Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
	Plug 'romgrk/fzy-lua-native'
	Plug 'nixprime/cpsm'
endif

" All of your Plugins must be added before the following line
call plug#end()            " required
filetype plugin indent on    " required

if !exists('g:vscode')
	call coc#add_extension('coc-pyright')
	call coc#add_extension('coc-sh')
	call coc#add_extension('coc-clangd')
	call coc#add_extension('coc-vimlsp')
	call coc#add_extension('coc-java')
	call coc#add_extension('coc-html')
	"call coc#add_extension('coc-css')
	call coc#add_extension('coc-json')
	call coc#add_extension('coc-yaml')
	call coc#add_extension('coc-markdownlint')
endif

if has("nvim")
	lua require('impatient')
	lua require('Comment').setup()
	lua require('gitsigns').setup()
	lua require'lspconfig'.pyright.setup{}
	lua require'lspconfig'.vimls.setup{}
	lua require'lspconfig'.bashls.setup{}
	lua require("inc_rename").setup()

" alpha "{{{
lua << EOF
	require'alpha'.setup(require'alpha.themes.dashboard'.config)
	local alpha = require'alpha'
	local dashboard = require'alpha.themes.dashboard'
	dashboard.section.header.val = {
		[[                               __                ]],
		[[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
		[[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
		[[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
		[[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
		[[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
	 }
	dashboard.section.buttons.val = {
	  dashboard.button( "e", "  New file" , ":ene <BAR> startinsert <CR>"),
	  dashboard.button("\\ f f", "  Find file", ":Telescope find_files hidden=true no_ignore=true<CR>"),
	  dashboard.button("\\ f h", "  Recently opened files", "<cmd>Telescope oldfiles<CR>"),
	  dashboard.button("\\ f g", "  Find word",  "<cmd>Telescope live_grep<cr>"),
	  dashboard.button("c", " " .. " Neovim config", ":e $MYVIMRC <CR>"),
	  dashboard.button("q", " " .. " Quit", ":qa<CR>"),
	}
	-- local handle = io.popen('fortune')
	-- local fortune = handle:read("*a")
	-- handle:close()
	-- dashboard.section.footer.val = fortune

	local function footer()
	  return "https://github.com/kiyoon/neovim-tmux-ide"
	end

	dashboard.section.footer.val = footer()

	dashboard.section.footer.opts.hl = "Type"
	dashboard.section.header.opts.hl = "Include"
	dashboard.section.buttons.opts.hl = "Keyword"

	dashboard.config.opts.noautocmd = true

	vim.cmd[[autocmd User AlphaReady echo 'ready']]

	alpha.setup(dashboard.config)
EOF
"}}}

" wilder.nvim{{{
lua << EOF
local wilder = require('wilder')
wilder.setup({modes = {':', '/', '?'}})

wilder.set_option('pipeline', {
  wilder.branch(
    wilder.python_file_finder_pipeline({
      file_command = function(ctx, arg)
        if string.find(arg, '.') ~= nil then
          return {'fd', '-tf', '-H'}
        else
          return {'fd', '-tf'}
        end
      end,
      dir_command = {'fd', '-td'},
      --filters = {'cpsm_filter'},
    }),
    wilder.substitute_pipeline({
      pipeline = wilder.python_search_pipeline({
        skip_cmdtype_check = 1,
        pattern = wilder.python_fuzzy_pattern({
          start_at_boundary = 0,
        }),
      }),
    }),
    wilder.cmdline_pipeline({
      fuzzy = 2,
      fuzzy_filter = wilder.lua_fzy_filter(),
    }),
    {
      wilder.check(function(ctx, x) return x == '' end),
      wilder.history(),
    },
    wilder.python_search_pipeline({
      pattern = wilder.python_fuzzy_pattern({
        start_at_boundary = 0,
      }),
    })
  ),
})

local gradient = {
  '#f4468f', '#fd4a85', '#ff507a', '#ff566f', '#ff5e63',
  '#ff6658', '#ff704e', '#ff7a45', '#ff843d', '#ff9036',
  '#f89b31', '#efa72f', '#e6b32e', '#dcbe30', '#d2c934',
  '#c8d43a', '#bfde43', '#b6e84e', '#aff05b'
}

for i, fg in ipairs(gradient) do
  gradient[i] = wilder.make_hl('WilderGradient' .. i, 'Pmenu', {{a = 1}, {a = 1}, {foreground = fg}})
end

local highlighters = wilder.highlighter_with_gradient({
  wilder.pcre2_highlighter(),
  wilder.lua_fzy_highlighter(),
})

local popupmenu_renderer = wilder.popupmenu_renderer(
  wilder.popupmenu_border_theme({
	pumblend = 20,
    border = 'rounded',
    empty_message = wilder.popupmenu_empty_message_with_spinner(),
    highlighter = highlighters,
    left = {
      ' ',
      wilder.popupmenu_devicons(),
      wilder.popupmenu_buffer_flags({
        flags = ' a + ',
        icons = {['+'] = '', a = '', h = ''},
      }),
    },
    right = {
      ' ',
      wilder.popupmenu_scrollbar(),
    },
    highlights = {
      --accent = wilder.make_hl('WilderAccent', 'Pmenu', {{a = 1}, {a = 1}, {foreground = '#f4468f'}}),
	  gradient = gradient,
    },
  })
)

local wildmenu_renderer = wilder.wildmenu_renderer({
  highlighter = highlighters,
  separator = ' · ',
  left = {' ', wilder.wildmenu_spinner(), ' '},
  right = {' ', wilder.wildmenu_index()},
  highlights = {
    --accent = wilder.make_hl('WilderAccent', 'Pmenu', {{a = 1}, {a = 1}, {foreground = '#f4468f'}}),
    gradient = gradient,
  },
})

wilder.set_option('renderer', wilder.renderer_mux({
  [':'] = popupmenu_renderer,
  ['/'] = wildmenu_renderer,
  substitute = wildmenu_renderer,
}))
EOF
"}}}

" nvim-tree"{{{
lua << EOF
	
	local nvim_tree = require('nvim-tree')
	local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
	if not config_status_ok then
	  return
	end

	local tree_cb = nvim_tree_config.nvim_tree_callback

	nvim_tree.setup {
		update_focused_file = {
		  enable = true,
		  update_cwd = true,
		},
		renderer = {
		  --root_folder_modifier = ":t",
		  icons = {
			glyphs = {
			  default = "",
			  symlink = "",
			  folder = {
				arrow_open = "",
				arrow_closed = "",
				default = "",
				open = "",
				empty = "",
				empty_open = "",
				symlink = "",
				symlink_open = "",
			  },
			  git = {
				unstaged = "",
				staged = "S",
				unmerged = "",
				renamed = "➜",
				untracked = "U",
				deleted = "",
				ignored = "◌",
			  },
			},
		  },
		},
		diagnostics = {
		  enable = true,
		  show_on_dirs = true,
		  icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		  },
		},
		view = {
		  width = 30,
		  side = "left",
		  mappings = {
			list = {
			  { key = "u", action = "dir_up" },
			  { key = "<F1>", action = "toggle_file_info" },
			  { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
			  { key = "h", cb = tree_cb "close_node" },
			  { key = "v", cb = tree_cb "vsplit" },
			},
		  },
		},
		remove_keymaps = {
		  '-',
		  '<C-k>',
		}
	}
EOF
"}}}
	
" nvim-treesitter"{{{
lua << EOF

	require('nvim-treesitter.configs').setup {
	  -- A list of parser names, or "all"
	  ensure_installed = { "c", "lua", "rust", "python", "bash", "json", "yaml", "html", "css", "vim", "java" },

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

	  textobjects = {
		select = {
		  enable = true,

		  -- Automatically jump forward to textobj, similar to targets.vim
		  lookahead = true,

		  keymaps = {
			-- You can use the capture groups defined in textobjects.scm
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["ac"] = "@class.outer",
			-- You can optionally set descriptions to the mappings (used in the desc parameter of
			-- nvim_buf_set_keymap) which plugins like which-key display
			["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
			["ab"] = "@block.outer",
			["ib"] = "@block.inner",
			["ad"] = "@conditional.outer",
			["id"] = "@conditional.inner",
			["ao"] = "@loop.outer",
			["io"] = "@loop.inner",
			["aa"] = "@parameter.outer",
			["ia"] = "@parameter.inner",
			["aC"] = "@call.outer",
			["iC"] = "@call.inner",

		  },
		  -- You can choose the select mode (default is charwise 'v')
		  --
		  -- Can also be a function which gets passed a table with the keys
		  -- * query_string: eg '@function.inner'
		  -- * method: eg 'v' or 'o'
		  -- and should return the mode ('v', 'V', or '<c-v>') or a table
		  -- mapping query_strings to modes.
		  selection_modes = {
			['@parameter.outer'] = 'v', -- charwise
			['@function.outer'] = 'V', -- linewise
			['@class.outer'] = '<c-v>', -- blockwise
		  },
		  -- if you set this to `true` (default is `false`) then any textobject is
		  -- extended to include preceding or succeeding whitespace. succeeding
		  -- whitespace has priority in order to act similarly to eg the built-in
		  -- `ap`.
		  --
		  -- can also be a function which gets passed a table with the keys
		  -- * query_string: eg '@function.inner'
		  -- * selection_mode: eg 'v'
		  -- and should return true of false
		  include_surrounding_whitespace = true,
		},
		swap = {
		  enable = true,
		  swap_next = {
			["<leader>a"] = "@parameter.inner",
		  },
		  swap_previous = {
			["<leader>a"] = "@parameter.inner",
		  },
		},
		move = {
		  enable = true,
		  set_jumps = true, -- whether to set jumps in the jumplist
		  goto_next_start = {
			["]m"] = "@function.outer",
			["]]"] = { query = "@class.outer", desc = "next class start" },
		  },
		  goto_next_end = {
			["]m"] = "@function.outer",
			["]["] = "@class.outer",
		  },
		  goto_previous_start = {
			["[m"] = "@function.outer",
			["[["] = "@class.outer",
		  },
		  goto_previous_end = {
			["[m"] = "@function.outer",
			["[]"] = "@class.outer",
		  },
		},
		lsp_interop = {
		  enable = true,
		  border = 'none',
		  peek_definition_code = {
			["<leader>df"] = "@function.outer",
			["<leader>df"] = "@class.outer",
		  },
		},
	  },

	}
EOF
"}}}

" indent_blankline{{{
lua << EOF
	vim.opt.list = true
	vim.opt.listchars:append "space:⋅"
	--vim.opt.listchars:append "eol:↴"

	require("indent_blankline").setup {
		space_char_blankline = " ",
		show_current_context = true,
		show_current_context_start = true,
	}
EOF
"}}}

" tokyonight"{{{
lua << EOF
	require("tokyonight").setup({
	  -- your configuration comes here
	  -- or leave it empty to use the default settings
	  style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
	  light_style = "day", -- The theme is used when the background is set to light
	  transparent = false, -- Enable this to disable setting the background color
	  terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
	  styles = {
		-- Style to be applied to different syntax groups
		-- Value is any valid attr-list value for `:help nvim_set_hl`
		comments = { italic = true },
		keywords = { italic = true },
		functions = {},
		variables = {},
		-- Background styles. Can be "dark", "transparent" or "normal"
		sidebars = "dark", -- style for sidebars, see below
		floats = "dark", -- style for floating windows
	  },
	  sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
	  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
	  hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
	  dim_inactive = false, -- dims inactive windows
	  lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold

	  --- You can override specific color groups to use other groups or a hex color
	  --- function will be called with a ColorScheme table
	  ---@param colors ColorScheme
	  on_colors = function(colors) end,

	  --- You can override specific highlights to use other groups or a hex color
	  --- function will be called with a Highlights and ColorScheme table
	  ---@param highlights Highlights
	  ---@param colors ColorScheme
	  on_highlights = function(highlights, colors) end,
	})
EOF
"}}}
endif


