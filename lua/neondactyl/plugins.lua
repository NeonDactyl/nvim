return require("lazy").setup({
  -- === Core UI & Navigation ===
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false, -- Load this plugin on startup
    dependencies = {
      "nvim-tree/nvim-web-devicons", -- Required for file icons
    },
    config = function()
      local keymaps = require("neondactyl.keymap")
      require("nvim-tree").setup {
        sort = {
          sorter = "case_sensitive",
        },
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true, -- Show dotfiles
        },
        on_attach = keymaps.setup_nvimtree_keymaps
      }
      -- Auto-open nvim-tree when Neovim starts without arguments
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if vim.fn.empty(vim.api.nvim_get_vvar("argv")) then
            vim.cmd("NvimTreeOpen")
          end
        end,
      })
      -- Auto-close nvim-tree if it's the only window
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("NvimTreeClose", { clear = true }),
        pattern = "NvimTree",
        callback = function(opts)
          local buf_info = vim.fn.getbufinfo(opts.bufnr)[1]
          if buf_info.loaded then
            local win_count = #vim.api.nvim_tabpage_list_wins(0)
            if win_count == 1 then
              vim.cmd("NvimTreeClose")
            end
          end
        end,
      })
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Needed for file icons in statusline
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto", -- 'auto' tries to pick a good theme or falls back to 'tokyonight' if available
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_last_status = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = {},
      })
    end,
  },

  {
    -- Choose a color scheme. You can try 'srcery-vim' if you prefer your coworker's,
    -- but 'folke/tokyonight.nvim' is a popular and well-supported choice.
    -- "srcery-colors/srcery-vim", -- Uncomment and use this if you want Srcery
    "folke/tokyonight.nvim",
    lazy = false, -- Load color scheme immediately
    priority = 1000, -- Make sure it loads before other plugins that might set colors
    config = function()
      vim.cmd.colorscheme("tokyonight-night") -- Set your preferred variant (e.g., 'tokyonight-day', 'tokyonight-moon', 'tokyonight-storm')
    end,
  },

  -- === Markdown Preview (from your init.lua, integrated here) ===
  -- Note: You still need to install the Node.js dependencies outside of Neovim.
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install", -- Or "yarn install"
    ft = "markdown", -- Load only for markdown files
    config = function()
      vim.g.mkdp_browser = "firefox" -- Use Firefox as configured in init.lua function
      vim.g.mkdp_port = "8888" -- Optional: specify a port
      -- Your custom function from init.lua is still active for mkdp_browser
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_filetypes = { "markdown" } -- Ensure only markdown triggers it
    end,
  },

  -- === Auto-pairing and Comments ===
  {
    "windwp/nvim-autopairs",
    event = "InsertCharPre", -- Load when typing
    config = function()
      require("nvim-autopairs").setup {}
    end,
  },

  {
    "numToStr/Comment.nvim",
    event = "BufReadPre", -- Load on buffer read
    config = function()
      require("Comment").setup()
    end,
  },
  {
    "Tsuzat/NeoSolarized.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd [[ colorscheme NeoSolarized ]]
    end
  },

  -- === Git Integration ===
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre", -- Load when opening a buffer
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "▎" },
          change = { text = "▎" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "▎" },
          untracked = { text = "┆" },
        },
        signcolumn = true, -- Toggle with `:GitsignsToggleSignColumn`
        numhl = false,     -- Toggle with `:GitsignsToggleNumhl`
        linehl = false,    -- Toggle with `:GitsignsToggleLinehl`
        word_diff = false, -- Toggle with `:GitsignsToggleWordDiff`
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false, -- Toggle with `:GitsignsToggleBlameLine`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
          delay = 100,
          ignore_whitespace = false,
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
        sign_priority = 6,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          -- Options for vim.fn.diffview()
          winblend = 0,
          border = "single",
          style = "minimal",
          row = 0,
          col = 1,
        },
      })
    end,
  },

  -- === Fuzzy Finder ===
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.x", -- Or use `branch = "0.1.x"` if `tag` causes issues
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required dependency
      "nvim-tree/nvim-web-devicons", -- For icons in results
    },
    cmd = "Telescope", -- Lazy load on first use of :Telescope
    config = function()
      require("telescope").setup({
        defaults = {
          -- Default options for all pickers
          -- See :help telescope.defaults
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
        },
        pickers = {
          -- Picker specific options
        },
        extensions = {
          -- Load extensions here
        },
      })
      -- Enable Telescope extensions if any
      -- require('telescope').load_extension('fzf')
      -- require('telescope').load_extension('media_files')
    end,
  },

  -- === Treesitter for better syntax highlighting ===
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate", -- Run this command after installation to download parsers
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects", -- Enhances text objects for treesitter
      "nvim-treesitter/playground", -- For debugging/understanding treesitter (optional, can remove later)
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          -- Core languages for your setup
          "c_sharp", -- For C#
          "typescript", "javascript", "tsx", -- For TypeScript/JavaScript/TSX
          "json", "yaml", "html", "css", -- General web/config
          "lua",     -- For Neovim config files themselves
          "markdown", "markdown_inline", -- For Markdown
        },
        sync_install = false, -- Install parsers synchronously (good for initial setup)
        auto_install = true,  -- Automatically install missing parsers
        highlight = {
          enable = true,      -- Enable syntax highlighting
          additional_vim_regex_highlighting = false, -- Prefer Treesitter over Vim regex
        },
        indent = {
          enable = true,      -- Enable indentation based on Treesitter
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              -- You can add/customize text object keymaps here
              -- For example, `vaS` to select a sentence, `ac` to select a class
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- adds local jumps to the jump list
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25,
          persist_queries = false,
          keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
          },
        },
      })
    end,
  },

  -- === LSP and Completion ===
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip", -- Snippet engine (alternative to vim-vsnip, often preferred with Lua)
      "saadparwaiz1/cmp_luasnip", -- cmp source for LuaSnip
      "j-hui/fidget.nvim", -- LSP progress indicator
      "folke/trouble.nvim", -- LSP diagnostics viewer
    },
    config = function()
      require("neondactyl.lsp_config")
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = "ToggleTerm",
    config = function()
      require("toggleterm").setup({

      })
    end,
  },

  -- === Optional but Recommended ===
-- In your plugins.lua, find the which-key config block:

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    -- The 'opts' table here is for the plugin's global setup options,
    -- NOT for the individual keymap registrations.
    opts = {}, -- Keep this empty or with global which-key options
    config = function()
      local wk = require("which-key")
      wk.setup({})
      local custom_keymaps = require("neondactyl.keymap")
      custom_keymaps.setup_global_whichkey_maps(wk)
    end,
  },

  {
    "tpope/vim-fugitive", -- Git wrapper
  },
  {
    "tpope/vim-commentary", -- Easy commenting
  },

  -- === F# specific (Integrate with Ionide-vim if needed, but fsharp_language_server handles core LSP) ===
  -- The fsharp_language_server via Mason usually covers most needs.
  -- "ionide/Ionide-vim", -- This might be redundant or conflict with fsharp_language_server, test carefully.
                       -- If you use it, ensure its config doesn't clash with mason-lspconfig.
                       -- Often, it's used for F# specific commands or tools rather than LSP itself.

  -- Other highly recommended general development plugins you can add later:
  -- "mfussenegger/nvim-dap", -- Debug Adapter Protocol client (for debugging)
  -- "rcarriga/nvim-dap-ui", -- UI for nvim-dap
  -- "nvimtools/none-ls.nvim", -- For additional formatters/linters not covered by LSP
  -- "jay-babu/mason-null-ls.nvim", -- Mason integration for none-ls
})
