return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "poimandres",
    },
  },
  {
    "MagicDuck/grug-far.nvim",
    enabled = false,
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      scroll = { enabled = false },
      dashboard = {
        preset = {
          header = [[
d8888b. d8888b.  .d88b.  db    db d88888b d8888b. d8888b. .d8888.    db  .d88b.       j88D  
88  `8D 88  `8D .8P  Y8. 88    88 88'     88  `8D 88  `8D 88'  YP   o88 .8P  88. db  j8~88  
88oodD' 88oobY' 88    88 Y8    8P 88ooooo 88oobY' 88oooY' `8bo.      88 88  d'88 VP j8' 88  
88~~~   88`8b   88    88 `8b  d8' 88~~~~~ 88`8b   88~~~b.   `Y8b.    88 88 d' 88    V88888D 
88      88 `88. `8b  d8'  `8bd8'  88.     88 `88. 88   8D db   8D    88 `88  d8' db     88  
88      88   YD  `Y88P'     YP    Y88888P 88   YD Y8888P' `8888Y'    VP  `Y88P'  VP     VP  

ראש עשה כף־רמיה ויד חרוצים תעשיר׃
        ]],
          keys = {
            { icon = " ", key = "r", desc = "Restore Session", section = "session" },
            { icon = " ", key = "s", desc = "Open Session", action = "<leader>qS" },
            { icon = "󰐅 ", key = "1", desc = "Update Treesitter", action = ":TSUpdate" },
            { icon = "󰚰 ", key = "2", desc = "Update  Mason", action = ":MasonUpdate" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
  },
  {
    "ibhagwan/fzf-lua", -- Use fzf-lua instead of Telescope
    dependencies = {
      -- Ensure fzf-native is installed for performance
      "nvim-tree/nvim-web-devicons", -- Optional: icons for fzf-lua
    },
    keys = {
      -- Buffers
      {
        "<leader>,",
        "<cmd>FzfLua buffers sort='mru'<cr>",
        desc = "Switch Buffer (MRU)",
      },
      -- File and Grep
      {
        "<leader><space>",
        "<cmd>FzfLua files<cr>",
        desc = "Find Files (Root Dir)",
      },
      { "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Grep (Root Dir)" },
      { "<leader>fc", "<cmd>FzfLua files cwd=~/.config/nvim<cr>", desc = "Find Config File" },
      { "<leader>fp", "<cmd>FzfLua files cwd=~/.local/share/nvim/lazy<cr>", desc = "Find Plugin File" },

      -- Git Commands
      { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Git Status" },
      { "<leader>gr", "<cmd>FzfLua git_branches<cr>", desc = "Git Branches" },
      { "<leader>gS", "<cmd>FzfLua git_stash<cr>", desc = "Git Stash" },

      -- LSP
      { "<leader>ss", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Goto Symbol" },
      { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
      { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume Last Search" },

      -- Visual Mode Grep
      {
        "<leader>sw",
        ":<C-u>FzfLua grep_visual<CR>",
        mode = "v",
        desc = "Grep Selection (Root Dir)",
      },
      {
        "<leader>:",
        "<cmd>FzfLua commands<cr>",
        desc = "Commands",
      },
    },
    opts = {
      -- files = {
      --   fd_opts = "--hidden --exclude .git --exclude node_modules", -- fd options
      -- },
      -- grep = {
      --   rg_opts = "--column --line-number --no-heading --color=always --smart-case -g '!node_modules/'",
      -- },
      keymap = {
        fzf = {
          ["ctrl-k"] = "preview-up",
          ["ctrl-j"] = "preview-down",
          ["ctrl-o"] = "select-all+accept",
        },
        builtin = {
          ["<C-Up>"] = "preview-page-up",
          ["<C-Down>"] = "preview-page-down",
        },
      },
      winopts = {
        height = 0.85,
        width = 0.9,
        -- border = "single",
        hl = {
          normal = "TelescopeNormal",
          border = "TelescopeBorder",
          title = "TelescopePromptTitle",
          help_normal = "TelescopeNormal",
          help_border = "TelescopeBorder",
          preview_normal = "TelescopeNormal",
          preview_border = "TelescopeBorder",
          preview_title = "TelescopePreviewTitle",
          -- builtin preview only
          cursor = "Cursor",
          cursorline = "TelescopeSelection",
          cursorlinenr = "TelescopeSelection",
          search = "IncSearch",
        },
        -- hl = {
        --   border = "Comment",
        --   preview_border = "Comment",
        --   preview_title = "FzfTitle",
        --   title = "FzfTitle",
        --   help_normal = "Comment",
        -- },
        preview = {
          -- layout = "vertical", -- Preview layout
          layout = "flex",
          flip_columns = 120,
          delay = 10,
          winopts = { number = false },
          scrollbar = "border",
        },
      },
      fzf_opts = {
        ["--ansi"] = true,
        ["--prompt"] = "❯ ",
        ["--info"] = "inline",
      },
      defaults = {
        silent = true,
        git_icons = false,
        file_icons = false,
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional for icons
    -- config = function()
    --   require("lualine").setup({
    --     options = {
    --       icons_enabled = true,
    --       component_separators = { left = "|", right = "|" },
    --       section_separators = { left = "█", right = "█" },
    --     },
    --   })
    -- end,
    opts = function(_, opts)
      opts.options.component_separators = { left = "|", right = "|" }
      opts.options.section_separators = { left = "█", right = "█" }
      if not vim.g.trouble_lualine then
        table.insert(opts.sections.lualine_c, { "navic", color_correction = "dynamic" })
      end
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>fe", false },
      { "<leader>fE", false },
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd(), position = "right" })
        end,
        desc = "Explorer NeoTree (Root Dir)",
        remap = true,
      },
      { "<leader>E", false },
      { "<leader>ge", false },
      { "<leader>be", false },
    },
    opts = {
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      document_symbols = {
        window = {
          mappings = {
            ["a"] = "toggle_node",
          },
        },
      },
    },
  },
}
