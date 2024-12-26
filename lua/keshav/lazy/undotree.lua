return {
    "mbbill/undotree",

    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1 -- auto focus on window when toggling it
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
    end
}
