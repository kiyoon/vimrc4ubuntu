return {
  -- the colorscheme should be available when starting Neovim
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     -- load the colorscheme here
  --     require('user.tokyonight')
  --     vim.cmd([[colorscheme tokyonight-night]])
  --   end,
  -- },
  {
    "Mofiqul/dracula.nvim",
    lazy = false,
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd [[colorscheme dracula]]
    end,
  },
  {
    "kiyoon/tmuxsend.vim",
    keys = {
      { "-", "<Plug>(tmuxsend-smart)", mode = { "n", "x" }, desc = "Send to tmux (smart)" },
      { "_", "<Plug>(tmuxsend-plain)", mode = { "n", "x" }, desc = "Send to tmux (plain)" },
      { "<space>-", "<Plug>(tmuxsend-uid-smart)", mode = { "n", "x" }, desc = "Send to tmux w/ pane uid (smart)" },
      { "<space>_", "<Plug>(tmuxsend-uid-plain)", mode = { "n", "x" }, desc = "Send to tmux w/ pane uid (plain)" },
      { "<C-_>", "<Plug>(tmuxsend-tmuxbuffer)", mode = { "n", "x", desc = "Yank to tmux buffer" } },
    },
  },
  {
    "kiyoon/jupynium.nvim",
    -- build = "conda run --no-capture-output -n jupynium pip install .",
    build = "~/bin/miniconda3/envs/jupynium/bin/pip install .[extra]",
    enabled = vim.fn.isdirectory(vim.fn.expand "~/bin/miniconda3/envs/jupynium"),
    config = function()
      require "user.jupynium"
    end,
    dev = true,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "wookayin/vim-autoimport",
    ft = { "python" },
    keys = {
      { "<M-CR>", ":ImportSymbol<CR>" },
      { "<M-CR>", "<Esc>:ImportSymbol<CR>a", mode = "i" },
    },
  },
  {
    -- <space>siwie to substitute word from entire buffer
    -- <space>siwip to substitute word from paragraph
    -- <space>siwif to substitute word from function
    -- <space>siwic to substitute word from class
    -- <space>ssip to substitute word from paragraph
    "svermeulen/vim-subversive",
    keys = {
      { "<space>s", "<plug>(SubversiveSubstituteRange)", mode = { "n", "x" } },
      { "<space>ss", "<plug>(SubversiveSubstituteWordRange)", mode = { "n" } },
    },
  },

  { "tpope/vim-surround" },
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  { "kana/vim-textobj-user" },
  { "kana/vim-textobj-entire", dependencies = { "kana/vim-textobj-user" } }, -- vie, vae to select entire buffer (file)
  { "kana/vim-textobj-fold", dependencies = { "kana/vim-textobj-user" } }, -- viz, vaz to select fold
  { "glts/vim-textobj-comment", dependencies = { "kana/vim-textobj-user" } }, -- vic, vac

  {
    "chaoren/vim-wordmotion",
    -- use init instead of config to set variables before loading the plugin
    init = function()
      vim.g.wordmotion_prefix = "<space>"
    end,
  },
  "github/copilot.vim",
  {
    "nvim-lualine/lualine.nvim",
    cond = (vim.fn.exists "g:started_by_firenvim" or vim.fn.exists "g:vscode") == 0,
    config = function()
      require("lualine").setup()
    end,
  },

  { "nvim-lua/plenary.nvim" },
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>dv", ":DiffviewOpen<CR>" },
      { "<leader>dc", ":DiffviewClose<CR>" },
      { "<leader>dq", ":DiffviewClose<CR>:q<CR>" },
    },
    cmd = { "DiffviewOpen", "DiffviewClose" },
  },

  {
    "smjonas/inc-rename.nvim",
    keys = {
      {
        "<space>pr",
        function()
          return ":IncRename " .. vim.fn.expand "<cword>"
        end,
        expr = true,
        desc = "LSP (R)ename",
      },
    },
    config = function()
      require("inc_rename").setup()
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup {
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local tstext = require "nvim-treesitter.textobjects.repeatable_move"

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          local next_hunk, prev_hunk = tstext.make_repeatable_move_pair(gs.next_hunk, gs.prev_hunk)
          -- Navigation
          map("n", "]h", function()
            if vim.wo.diff then
              return "]h"
            end
            vim.schedule(function()
              next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          map("n", "[h", function()
            if vim.wo.diff then
              return "[h"
            end
            vim.schedule(function()
              prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          -- Actions
          map({ "n", "v" }, "<leader>hs", ":Gitsigns stage_hunk<CR>")
          map({ "n", "v" }, "<leader>hr", ":Gitsigns reset_hunk<CR>")
          map("n", "<leader>hS", gs.stage_buffer)
          map("n", "<leader>hu", gs.undo_stage_hunk)
          map("n", "<leader>hR", gs.reset_buffer)
          map("n", "<leader>hp", gs.preview_hunk)
          map("n", "<leader>hb", function()
            gs.blame_line { full = true }
          end)
          map("n", "<leader>tb", gs.toggle_current_line_blame)
          map("n", "<leader>hd", gs.diffthis)
          map("n", "<leader>hD", function()
            gs.diffthis "~"
          end)
          map("n", "<leader>td", gs.toggle_deleted)

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
        end,
      }
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    -- keys = {
    --   "<space>nt",
    -- },
    -- cmds = {
    --   "NvimTreeToggle",
    -- },
    config = function()
      require "user.nvim_tree"
    end,
  },

  {
    "akinsho/bufferline.nvim",
    cond = (vim.fn.exists "g:started_by_firenvim" or vim.fn.exists "g:vscode") == 0,
    config = function()
      require "user.bufferline"
    end,
  },

  -- Treesitter Better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require "user.treesitter"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    -- dev = true,
  },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "nvim-treesitter/playground" },
  {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require "user.indent_blankline"
    end,
  },
  { "kiyoon/treesitter-indent-object.nvim" },
  -- { 'RRethy/nvim-treesitter-textsubjects' }
  --
  -- % to match up if, else, etc. Enabled in the treesitter config below
  { "andymass/vim-matchup" },
  { "mrjones2014/nvim-ts-rainbow" },
  { "Wansmer/treesj" },

  -- Hop, leap
  {
    "phaazon/hop.nvim",
    config = function()
      require "user.hop"
    end,
  },
  { "mfussenegger/nvim-treehopper" },
  {
    "ggandor/leap.nvim",
    dependencies = {
      "tpope/vim-repeat",
    },
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  { "mizlan/iswap.nvim", dependencies = {
    "nvim-treesitter/nvim-treesitter",
  } },

  -- Dashboard
  {
    "goolord/alpha-nvim",
    config = function()
      require "user.alpha"
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    config = function()
      require "user.telescope"
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    enabled = vim.fn.executable "make" == 1,
    config = function()
      require("telescope").load_extension "fzf"
    end,
  },

  { "kiyoon/telescope-insert-path.nvim" },

  -- Beautiful command menu
  {
    "gelguy/wilder.nvim",
    dependencies = {
      "romgrk/fzy-lua-native",
      "nixprime/cpsm",
    },
    config = function()
      require "user.wilder"
    end,
  },

  -- LSP
  -- CoC supports out-of-the-box features like inlay hints
  -- which isn't possible with native LSP yet.
  {
    "neoclide/coc.nvim",
    branch = "release",
    cond = vim.g.vscode == nil,
    init = function()
      vim.cmd [[ autocmd FileType lua,python let b:coc_suggest_disable = 1 ]]
    end,
    config = function()
      vim.cmd [[
        hi link CocInlayHint Comment
        call coc#add_extension('coc-pyright')
        call coc#add_extension('coc-sh')
        call coc#add_extension('coc-clangd')
        call coc#add_extension('coc-vimlsp')
        call coc#add_extension('coc-java')
        call coc#add_extension('coc-html')
        call coc#add_extension('coc-css')
        call coc#add_extension('coc-json')
        call coc#add_extension('coc-yaml')
        call coc#add_extension('coc-markdownlint')
        " call coc#add_extension('coc-sumneko-lua')
        " call coc#add_extension('coc-snippets')
      ]]
    end,
  },

  -- Mason makes it easier to install language servers
  -- Always load mason, mason-lspconfig and nvim-lspconfig in order.
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "neovim/nvim-lspconfig" },
  { "folke/neodev.nvim" },
  {
    "hrsh7th/nvim-cmp",
    -- load cmp on InsertEnter
    -- event = "InsertEnter",
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-calc",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require "user.lsp.cmp"
    end,
  },
  {
    "lvimuser/lsp-inlayhints.nvim",
    -- lazy = false,
    config = function()
      vim.cmd [[hi link LspInlayHint Comment]]
      -- vim.cmd [[hi LspInlayHint guifg=#d8d8d8 guibg=#3a3a3a]]
      require("lsp-inlayhints").setup()

      vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
      vim.api.nvim_create_autocmd("LspAttach", {
        group = "LspAttach_inlayhints",
        callback = function(args)
          if not (args.data and args.data.client_id) then
            return
          end

          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          require("lsp-inlayhints").on_attach(client, bufnr)
        end,
      })
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    config = function()
      local cfg = {
        on_attach = function(client, bufnr)
          require("lsp_signature").on_attach({
            bind = true, -- This is mandatory, otherwise border config won't get registered.
            handler_opts = {
              border = "rounded",
            },
          }, bufnr)
        end,
        debug = true, -- set to true to enable debug logging
        log_path = vim.fn.stdpath "cache" .. "/lsp_signature.log", -- log dir when debug is on
        -- default is  ~/.cache/nvim/lsp_signature.log
        verbose = true, -- show debug line number
      }
      require("lsp_signature").setup(cfg)
    end,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    version = "v1.x",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require "user.luasnip"
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require "user.lsp.null-ls"
    end,
  },
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup()
    end,
  },

  -- LSP diagnostics
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
        auto_open = false,
        auto_close = true,
        auto_preview = true,
        auto_fold = true,
      }
      -- Lua
      vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
      vim.keymap.set(
        "n",
        "<leader>xw",
        "<cmd>TroubleToggle workspace_diagnostics<cr>",
        { silent = true, noremap = true }
      )
      vim.keymap.set(
        "n",
        "<leader>xd",
        "<cmd>TroubleToggle document_diagnostics<cr>",
        { silent = true, noremap = true }
      )
      vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true, noremap = true })
      vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true })
      vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true, noremap = true })
    end,
  },

  -- 'doums/dmap.nvim',

  -- DAP (Debugger)
  "mfussenegger/nvim-dap",
  "mfussenegger/nvim-dap-python",
  "rcarriga/nvim-dap-ui",
  "Weissle/persistent-breakpoints.nvim",

  {
    "aserowy/tmux.nvim",
    config = function()
      require("tmux").setup {
        copy_sync = {
          enable = true,
          sync_clipboard = false,
          sync_registers = true,
        },
        resize = {
          enable_default_keybindings = false,
        },
      }
    end,
  },
  {
    "RRethy/vim-illuminate",
    config = function()
      require "user.illuminate"
    end,
  },

  -- UI
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup {
        stages = "fade_in_slide_out",
      }
      vim.notify = require "notify"
    end,
  },
  {
    -- For treemux
    "kiyoon/nvim-tree-remote.nvim",
    cond = false,
  },
  {
    -- For treemux
    "folke/tokyonight.nvim",
    cond = false,
  },
  -- {
  --   "folke/noice.nvim",
  --   config = function()
  --     require("noice").setup {
  --       lsp = {
  --         -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
  --         override = {
  --           ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
  --           ["vim.lsp.util.stylize_markdown"] = true,
  --           ["cmp.entry.get_documentation"] = true,
  --         },
  --       },
  --       -- you can enable a preset for easier configuration
  --       presets = {
  --         bottom_search = true, -- use a classic bottom cmdline for search
  --         command_palette = true, -- position the cmdline and popupmenu together
  --         long_message_to_split = true, -- long messages will be sent to a split
  --         inc_rename = false, -- enables an input dialog for inc-rename.nvim
  --         lsp_doc_border = false, -- add a border to hover docs and signature help
  --       },
  --     }
  --   end,
  --   dependencies = {
  --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
  --     "MunifTanjim/nui.nvim",
  --     -- OPTIONAL:
  --     --   `nvim-notify` is only needed, if you want to use the notification view.
  --     --   If not available, we use `mini` as the fallback
  --     "rcarriga/nvim-notify",
  --   },
  -- },
  "folke/lsp-colors.nvim",
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 600
      require("which-key").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
      vim.keymap.set("n", "]t", function()
        require("todo-comments").jump_next()
      end, { desc = "Next todo comment" })

      vim.keymap.set("n", "[t", function()
        require("todo-comments").jump_prev()
      end, { desc = "Previous todo comment" })

      -- You can also specify a list of valid jump keywords

      -- vim.keymap.set("n", "]t", function()
      --   require("todo-comments").jump_next({keywords = { "ERROR", "WARNING" }})
      -- end, { desc = "Next error/warning todo comment" })
    end,
  },
  -- {
  --   "toppair/peek.nvim",
  --   ft = "markdown",
  --   build = "deno task --quiet build:fast",
  --   config = function()
  --     vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
  --     vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
  --     require("peek").setup {
  --       auto_load = true, -- whether to automatically load preview when
  --       -- entering another markdown buffer
  --       close_on_bdelete = true, -- close preview window on buffer delete
  --
  --       syntax = true, -- enable syntax highlighting, affects performance
  --
  --       theme = "light", -- 'dark' or 'light'
  --
  --       update_on_change = true,
  --
  --       -- relevant if update_on_change is true
  --       throttle_at = 200000, -- start throttling when file exceeds this
  --       -- amount of bytes in size
  --       throttle_time = "auto", -- minimum amount of time in milliseconds
  --       -- that has to pass before starting new render
  --     }
  --   end,
  -- },

  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    -- build = "cd app && yarn install",
    build = ":call mkdp#util#install()",
  },
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("refactoring").setup()
      -- Remaps for the refactoring operations currently offered by the plugin
      vim.api.nvim_set_keymap(
        "v",
        "<space>re",
        [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
        { noremap = true, silent = true, expr = false }
      )
      vim.api.nvim_set_keymap(
        "v",
        "<space>rf",
        [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
        { noremap = true, silent = true, expr = false }
      )
      vim.api.nvim_set_keymap(
        "v",
        "<space>rv",
        [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
        { noremap = true, silent = true, expr = false }
      )
      vim.api.nvim_set_keymap(
        "v",
        "<space>ri",
        [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
        { noremap = true, silent = true, expr = false }
      )

      -- Extract block doesn't need visual mode
      vim.api.nvim_set_keymap(
        "n",
        "<space>rb",
        [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
        { noremap = true, silent = true, expr = false }
      )
      vim.api.nvim_set_keymap(
        "n",
        "<space>rbf",
        [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
        { noremap = true, silent = true, expr = false }
      )

      -- Inline variable can also pick up the identifier currently under the cursor without visual mode
      vim.api.nvim_set_keymap(
        "n",
        "<space>ri",
        [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
        { noremap = true, silent = true, expr = false }
      )
    end,
  },
  {
    "metakirby5/codi.vim",
    init = function()
      vim.g["codi#interpreters"] = {
        python = {
          bin = "python3",
        },
      }
      vim.g["codi#virtual_text_pos"] = "right_align"
    end,
    cmd = "Codi",
  },
  {
    "glacambre/firenvim",
    init = function()
      if vim.fn.exists "g:started_by_firenvim" then
        vim.o.laststatus = 0
        vim.cmd [[au BufEnter github.com_*.txt set filetype=markdown]]
        vim.g.firenvim_config = {
          globalSettings = {
            ["<C-w>"] = "noop",
            ["<C-n>"] = "default",
          },
        }
      end
    end,
    build = "firenvim#install(0)",
  },
  {
    "jackMort/ChatGPT.nvim",
    config = function()
      require("chatgpt").setup {
        -- optional configuration
      }
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
}
