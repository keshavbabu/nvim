return {
  "nvim-tree/nvim-tree.lua",
  config = function()
    local function my_on_attach(bufnr)
      local api = require "nvim-tree.api"

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set("n", "<cr>", api.node.open.replace_tree_buffer, opts("Open: In Place"))
    end

    require("nvim-tree").setup({
      on_attach = my_on_attach,
      filters = {
        dotfiles = false,
      },
    })

    vim.keymap.set("n", "<leader>pv", function()
      require("nvim-tree.api").tree.open({ current_window = true })
    end)
  end,
}
