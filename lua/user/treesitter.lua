local function starts_with(str, start)
  return str:sub(1, #start) == start
end
local function treesitter_selection_mode(info)
  -- * query_string: eg '@function.inner'
  -- * method: eg 'v' or 'o'
  --print(info['method'])		-- visual, operator-pending
  if starts_with(info['query_string'], '@function.') then
    return 'V'
  end
  return 'v'
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

require('nvim-treesitter.configs').setup {
  -- vim-matchup
  matchup = {
    enable = true,              -- mandatory, false will disable the whole extension
  },

  indent = {
    enable = true
  },

  -- v<cr> to select current context
  -- <cr> to increase selection
  -- , to undo
  -- v; to select the entire context container (eg function)
  -- vi; to select the entire context container (eg function) but inner part of it
  textsubjects = {
    enable = true,
    prev_selection = '.', -- (Optional) keymap to select the previous selection
    keymaps = {
      ['<cr>'] = 'textsubjects-smart',
      [';'] = 'textsubjects-container-outer',
      ['i;'] = 'textsubjects-container-inner',
    },
  },

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
        ["am"] = "@function.outer",
        ["im"] = "@function.inner",
        ["aC"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["iC"] = { query = "@class.inner", desc = "Select inner part of a class region" },
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
        ["ac"] = "@comment.outer",
        ["ic"] = "@comment.outer",
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
        [")C"] = "@class.outer",
      },
      swap_previous = {
        ["(m"] = "@function.outer",
        ["(c"] = "@comment.outer",
        ["(a"] = "@parameter.inner",
        ["(b"] = "@block.outer",
        ["(C"] = "@class.outer",
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
        ["]a"] = "@parameter.inner",
        ["]c"] = "@comment.outer",
        ["]b"] = "@block.outer",
        ["]]"] = { query = "@class.inner", desc = "next class start" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]F"] = "@call.outer",
        ["]D"] = "@conditional.outer",
        ["]O"] = "@loop.outer",
        ["]S"] = "@statement.outer",
        ["]A"] = "@parameter.inner",
        ["]C"] = "@comment.outer",
        ["]B"] = "@block.outer",
        ["]["] = "@class.inner",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[f"] = "@call.outer",
        ["[d"] = "@conditional.outer",
        ["[o"] = "@loop.outer",
        ["[s"] = "@statement.outer",
        ["[a"] = "@parameter.inner",
        ["[c"] = "@comment.outer",
        ["[b"] = "@block.outer",
        ["[["] = "@class.inner",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[F"] = "@call.outer",
        ["[D"] = "@conditional.outer",
        ["[O"] = "@loop.outer",
        ["[S"] = "@statement.outer",
        ["[A"] = "@parameter.inner",
        ["[C"] = "@comment.outer",
        ["[B"] = "@block.outer",
        ["[]"] = "@class.inner",
      },
    },
    lsp_interop = {
      enable = true,
      border = 'none',
      peek_definition_code = {
        ["<C-t>"] = "@function.outer",
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
}
