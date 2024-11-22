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
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
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
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      -- NOTE: If you are having trouble with this installation,
      --       refer to the README for telescope-fzf-native for more instructions.
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    keys = {
      {
        "<leader>,",
        "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
        desc = "Switch Buffer",
      },
      { "<leader>/", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader><space>", LazyVim.pick("files"), desc = "Find Files (Root Dir)" },
      -- find
      { "<leader>fb", false },
      { "<leader>fc", LazyVim.pick.config_files(), desc = "Find Config File" },
      { "<leader>ff", false },
      { "<leader>fF", false },
      { "<leader>fg", false },
      { "<leader>fr", false },
      { "<leader>fR", false },
      -- git
      { "<leader>gc", false },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
      -- search
      { '<leader>s"', false },
      { "<leader>sa", false },
      { "<leader>sb", false },
      { "<leader>sc", false },
      { "<leader>sC", false },
      { "<leader>sd", false },
      { "<leader>sD", false },
      { "<leader>sg", false },
      { "<leader>sG", false },
      { "<leader>sh", false },
      { "<leader>sH", false },
      { "<leader>sj", false },
      { "<leader>sk", false },
      { "<leader>sl", false },
      { "<leader>sM", false },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>so", false },
      { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
      { "<leader>sq", false },
      { "<leader>sw", false },
      { "<leader>sW", false },
      { "<leader>sw", LazyVim.pick("grep_string"), mode = "v", desc = "Selection (Root Dir)" },
      { "<leader>sW", false },
      { "<leader>uC", false },
      {
        "<leader>ss",
        function()
          require("telescope.builtin").lsp_document_symbols({
            symbols = LazyVim.config.get_kind_filter(),
          })
        end,
        desc = "Goto Symbol",
      },
      {
        "<leader>sS",
        false,
      },
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
      {
        "<leader>gS",
        function()
          require("telescope.builtin").git_stash()
        end,
        desc = "Git Stash",
      },
      {
        "<leader>gr",
        function()
          require("telescope.builtin").git_branches()
        end,
        desc = "Git B(r)anch",
      },
    },
    -- change some options
    opts = function()
      local actions = require("telescope.actions")
      local trouble = require("trouble.sources.telescope")
      return {
        defaults = {
          mappings = {
            i = {
              ["<C-w>"] = actions.select_vertical,
              ["<C-W>"] = actions.select_horizontal,
              ["<C-t>"] = trouble.open,
            },
            n = {
              ["<C-t>"] = trouble.open,
            },
          },
          files_ignore_patterns = {
            "node_modules",
          },
          layout_strategy = "horizontal",
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          winblend = 0,
        },
      }
    end,
  },
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>td", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xx", false },
      { "<leader>xX", false },
      { "<leader>cs", false },
      { "<leader>cS", false },
      { "<leader>xL", false },
      { "<leader>xQ", false },
    },
    opts = {
      modes = {
        telescope_files = {
          modes = "telescope_files",
          focus = true,
          preview = {
            type = "float",
            relative = "editor",
            border = "rounded",
            title = "Preview",
            title_pos = "center",
            position = { 0, -2 },
            size = { width = 0.7, height = 0.7 },
            zindex = 200,
          },
        },
      },
    },
    cmd = "Trouble",
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      if not vim.g.trouble_lualine then
        table.insert(opts.sections.lualine_c, { "navic", color_correction = "dynamic" })
      end
    end,
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      local edgy_idx = LazyVim.plugin.extra_idx("ui.edgy")
      local symbols_idx = LazyVim.plugin.extra_idx("editor.outline")

      if edgy_idx and edgy_idx > symbols_idx then
        LazyVim.warn(
          "The `edgy.nvim` extra must be **imported** before the `outline.nvim` extra to work properly.",
          { title = "LazyVim" }
        )
      end

      opts.right = opts.right or {}
      table.insert(opts.right, {
        title = "Outline",
        ft = "Outline",
        pinned = true,
        open = "Outline",
      })
    end,
  },
  {
    "hedyhli/outline.nvim",
    keys = { { "<leader>cs", "<cmd>Outline<cr>", desc = "Toggle Outline" } },
    cmd = "Outline",
    opts = function()
      local defaults = require("outline.config").defaults
      local opts = {
        symbols = {
          icons = {},
          filter = vim.deepcopy(LazyVim.config.kind_filter),
        },
        keymaps = {
          up_and_jump = "<up>",
          down_and_jump = "<down>",
        },
      }

      for kind, symbol in pairs(defaults.symbols.icons) do
        opts.symbols.icons[kind] = {
          icon = LazyVim.config.icons.kinds[kind] or symbol.icon,
          hl = symbol.hl,
        }
      end
      return opts
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "biome",
        "deno",
        "eslint-lsp",
        "json-lsp",
        "lua-language-server",
        "stylua",
        "tailwindcss-language-server",
        "typescript-language-server",
        "vtsls",
        "shfmt",
      },
    },
  },
}
