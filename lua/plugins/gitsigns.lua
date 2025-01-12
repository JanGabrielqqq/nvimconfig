return {
  {
    "lewis6991/gitsigns.nvim", -- Plugin name
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]h", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end)

          map("n", "[h", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end)

          -- Actions
          map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Git Signs Stage Hunk" })
          map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Git Signs Reset Hunk" })
          map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Git Signs Stage Hunk" })
          map("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
          end, { desc = "Git Signs Reset Hunk" })
          map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Git Signs Stage Buffer" })
          map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Git Signs Undo Stage Hunk" })
          map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Git Signs Reset Buffer" })
          map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Git Signs Preview Hunk" })
          map("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
          end, { desc = "Git Signs Blame Line" })
          map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Git Signs Toggle Current Line Blame" })
          map("n", "<leader>hd", gitsigns.diffthis, { desc = "Git Signs DiffThis" })
          map("n", "<leader>hD", function()
            gitsigns.diffthis("~")
          end, { desc = "Git Signs DiffThis (~)" })
          map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Git Signs Toggle Deleted" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Git Signs Select Hunk" })
        end,
      })
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
    opts_extend = { "ensure_installed" },
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
        "shfmt",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- FE
        "css",
        "html",
        "javascript",
        "jsdoc",
        "markdown",
        "markdown_inline",
        "scss",
        "tsx",
        "typescript",

        --BE
        "sql",
        "c",
        "c_sharp",

        -- misc
        "json",
        "json5",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "bash",
        "diff",
      },
    },
  },
}
