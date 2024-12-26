return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require('rose-pine').setup({
        disable_background = true,
        dim_inactive_windows = true,
        enable = {
          terminal = true,
          legacy_highlights = true,
          migrations = true,
        },
      })

      vim.cmd.colorscheme("rose-pine")
    end
  },
}
