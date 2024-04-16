return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      servers = {
        qmlls = {
          cmd_env = {
            PATH = "$PATH:/opt/qt/qt6/6.7.0/gcc_64/bin",
            LD_LIBRARY_PATH = "/opt/qt/qt6/6.7.0/gcc_64/lib:/opt/qt/qt6/Tools/QtDesignStudio/qt6_design_studio_reduced_version/lib",
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Add support for QML
      vim.list_extend(opts.ensure_installed, {
        "qmljs",
      })

      -- The `qmljs` parser expects QML files to have the `qmljs` extension.
      vim.filetype.add({
        extension = { qml = "qmljs" },
      })
    end,
  },
}
