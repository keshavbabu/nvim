return {
  "nvim-telescope/telescope.nvim",

  tag = "0.1.5",

  config = function()
    require('telescope').setup({})

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', function()
      -- need to find a way to only not include node_modules
      -- or ideally never write any code in js
      builtin.find_files()
    end, {})
    vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
    vim.keymap.set('n', '<leader>ps', function()
      builtin.grep_string({ search = vim.fn.input("rg > ") })
    end)
  end
}
