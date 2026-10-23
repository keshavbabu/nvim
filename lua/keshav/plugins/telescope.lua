require('telescope').setup({
  pickers = {
    find_files = {
      -- Respect .gitignore even in folders without a Git repository.
      find_command = { 'rg', '--files', '--color', 'never', '--no-require-git' },
    },
  },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("rg > ") })
end)
