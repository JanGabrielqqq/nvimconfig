return {
  {
    "olivercederborg/poimandres.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      local p = require("poimandres.palette")
      require("poimandres").setup({
        -- leave this setup function empty for default config
        fzf_colors = {
          ["fg"] = { "fg", "TelescopeNormal" },
          ["bg"] = { "bg", "TelescopeNormal" },
          ["hl"] = { "fg", "TelescopeMatching" },
          ["fg+"] = { "fg", "TelescopeSelection" },
          ["bg+"] = { "bg", "TelescopeSelection" },
          ["hl+"] = { "fg", "TelescopeMatching" },
          ["info"] = { "fg", "TelescopeMultiSelection" },
          ["border"] = { "fg", "TelescopeBorder" },
          ["gutter"] = { "bg", "TelescopeNormal" },
          ["query"] = { "fg", "TelescopePromptNormal" },
          ["prompt"] = { "fg", "TelescopePromptPrefix" },
          ["pointer"] = { "fg", "TelescopeSelectionCaret" },
          ["marker"] = { "fg", "TelescopeSelectionCaret" },
          ["header"] = { "fg", "TelescopeTitle" },
        },
        -- or refer to the configuration section
        -- for configuration options
        groups = {
          panel = p.background3,
        },
        highlight_groups = {
          LspReferenceText = { bg = "transparent", fg = p.yellow },
          LspReferenceRead = { bg = "transparent", fg = p.yellow },
          LspReferenceWrite = { bg = "transparent", fg = p.yellow },
          Search = { bg = p.teal1, fg = "#000000" },
          IncSearch = { bg = p.teal2, fg = "#000000" },
          Comment = { fg = p.blueGray3 },
          Function = { fg = p.teal1 },
          String = { fg = p.teal2 },
          Boolean = { fg = p.blue2 },
          Identifier = { fg = p.teal2 },
          Keyword = { fg = p.blue3 },
          Operator = { fg = p.blueGray2 },
          ["@punctuation.delimiter"] = { fg = p.blueGray2 },
          ["@punctuation.bracket"] = { fg = p.blueGray1 },
          ["@keyword.operator"] = { fg = p.blue3 },
          Include = { fg = p.teal3 },
          ["@constant.falsy"] = { fg = p.none },
          ["@keyword.export.typescript"] = { fg = p.blueGray3 },
          ["@keyword.export.javascript"] = { fg = p.blueGray3 },
          ["@keyword.export.tsx"] = { fg = p.blueGray3 },
          ["@keyword.export.jsx"] = { fg = p.blueGray3 },
          ["@keyword.import.typescript"] = { fg = p.blueGray2 },
          ["@keyword.import.javascript"] = { fg = p.blueGray2 },
          ["@keyword.import.tsx"] = { fg = p.blueGray2 },
          ["@keyword.import.jsx"] = { fg = p.blueGray2 },
          ["@lsp.type.parameter.typescript"] = { fg = p.blue2 },
          ["@lsp.type.parameter.javascript"] = { fg = p.blue2 },
          ["@variable.member.javascript"] = { fg = p.blueGray1 },
          ["@variable.member.typescript"] = { fg = p.blueGray1 },
          ["@tag.attribute"] = { fg = p.blue2 },
          ["@variable"] = { fg = p.blue2 },
          ["@variable.parameter"] = { fg = p.white },
          Type = { fg = p.blue1 },
          DiagnosticUnnecessary = { fg = p.blueGray3 },
          Special = { fg = p.teal2 },
          htmlTagName = { fg = p.teal2 },
          LineNr = { fg = p.blueGray1 },
          FloatBorder = { fg = p.background1 },
          WinSeparator = { fg = p.background1 },
          TroublePreview = { fg = p.background1 },
          LspSignatureActiveParameter = { fg = p.background2, bg = p.blue1 },
          SnacksDashboardHeader = { fg = p.teal3 },
          SnacksDashboardFooter = { fg = p.teal3 },
          SnacksDashboardDesc = { fg = p.teal1 },
          SnacksDashboardKey = { fg = p.teal1 },
          SnacksDashboardIcon = { fg = p.teal3 },
          FzfTitle = { fg = p.background3, bg = p.blue3 },
        },
        bold_vert_split = true,
        dim_nc_background = true, -- dim 'non-current' window backgrounds
        disable_background = true, -- disable background
        disable_float_background = true, -- disable background for floats
      })
    end,

    -- optionally set the colorscheme within lazy config
    init = function()
      vim.cmd("colorscheme poimandres")
    end,
  },
  {
    "themaxmarchuk/tailwindcss-colors.nvim",
  },
}
