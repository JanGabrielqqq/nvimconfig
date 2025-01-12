return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- Keybindings for TypeScript
          vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { buffer = buffer, desc = "Rename File" })
        end)
      end,
    },
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- ts_ls will be automatically installed with mason and loaded with lspconfig
        ts_ls = {},
        denols = {},
        tailwindcss = {},
        omnisharp = {
          cmd = { "omnisharp" },
          root_dir = require("lspconfig.util").root_pattern(".sln", ".csproj", ".git"),
          settings = {
            omnisharp = {
              useModernNet = true,
              enableRoslynAnalyzers = true,
              organizeImportsOnFormat = true,
            },
          },
        },
        -- vtsls = {}, -- if you want vtsls support
      },
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        -- Setup ts_ls with condition
        ts_ls = function(_, opts)
          local lspconfig = require("lspconfig")
          local is_deno_project = function(fname)
            return lspconfig.util.root_pattern("deno.json", "deno.jsonc")(fname) ~= nil
          end

          -- Only setup ts_ls if not a Deno project
          opts.root_dir = function(fname)
            if is_deno_project(fname) then
              return nil
            end
            return lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git")(fname)
          end

          opts.on_attach = function(client, bufnr)
            if not client.config.root_dir then
              client.stop()
              return
            end
          end

          require("typescript").setup({ server = opts })
          return true -- Prevent LazyVim from setting up ts_ls again
        end,

        -- Setup denols
        denols = function(_, opts)
          local lspconfig = require("lspconfig")

          opts.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
          opts.on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
          end

          lspconfig.denols.setup(opts)
          return true -- Prevent LazyVim from setting up denols again
        end,

        tailwindcss = function(_, opts)
          local lspconfig = require("lspconfig")

          opts.settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  { "clsx%(([^%)]*)%)", "%1" }, -- Matches clsx(...)
                  { "twMerge%(([^%)]*)%)", "%1" }, -- Matches twMerge(...)
                },
              },
              classAttributes = {
                "class",
                "className",
                "ngClass",
                "style",
                "styles",
                "base",
                "buttonVariants",
                "tv",
                "twMerge",
                "cx",
                "clsx",
              },
            },
          }

          lspconfig.tailwindcss.setup(opts)
          return true
        end,
        -- NOTE: Setup vtsls (optional, if used)

        -- vtsls = function(_, opts)
        --   local lspconfig = require("lspconfig")
        --   local is_deno_project = function(fname)
        --     return lspconfig.util.root_pattern("deno.json", "deno.jsonc")(fname) ~= nil
        --   end
        --
        --   opts.root_dir = function(fname)
        --     if is_deno_project(fname) then
        --       return nil
        --     end
        --     return lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git")(fname)
        --   end
        --
        --   lspconfig.vtsls.setup(opts)
        --   return true -- Prevent LazyVim from setting up vtsls again
        -- end,
        omnisharp = function(_, opts)
          local lspconfig = require("lspconfig")
          opts.enable_roslyn_analysers = true
          opts.enable_import_completion = true
          opts.organize_imports_on_format = true
          lspconfig.omnisharp.setup(opts)
          return true
        end,
      },
    },
  },
}
