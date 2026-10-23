local build_group = vim.api.nvim_create_augroup("PackageBuilds", { clear = true })
vim.api.nvim_create_autocmd("PackChanged", {
  group = build_group,
  callback = function(event)
    local package = event.data
    if package.kind ~= "install" and package.kind ~= "update" then
      return
    end

    if package.spec.name == "nvim-treesitter" then
      vim.cmd.packadd("nvim-treesitter")
      require("nvim-treesitter").update():wait(300000)
    end
  end,
})

vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim.git",                 name = "plenary.nvim",      version = "master" },
  { src = "https://github.com/L3MON4D3/LuaSnip.git",                      name = "LuaSnip",           version = "master" },
  { src = "https://github.com/hrsh7th/nvim-cmp.git",                      name = "nvim-cmp",          version = "main" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp.git",                  name = "cmp-nvim-lsp",      version = "main" },
  { src = "https://github.com/hrsh7th/cmp-buffer.git",                    name = "cmp-buffer",        version = "main" },
  { src = "https://github.com/hrsh7th/cmp-path.git",                      name = "cmp-path",          version = "main" },
  { src = "https://github.com/hrsh7th/cmp-cmdline.git",                   name = "cmp-cmdline",       version = "main" },
  { src = "https://github.com/saadparwaiz1/cmp_luasnip.git",              name = "cmp_luasnip",       version = "master" },
  { src = "https://github.com/stevearc/conform.nvim.git",                 name = "conform.nvim",      version = "master" },
  { src = "https://github.com/j-hui/fidget.nvim.git",                     name = "fidget.nvim",       version = "main" },
  { src = "https://github.com/williamboman/mason.nvim.git",               name = "mason.nvim",        version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter.git",       name = "nvim-treesitter",   version = "main" },
  { src = "https://github.com/rose-pine/neovim.git",                      name = "rose-pine",         version = "main" },
  { src = "https://github.com/nvim-telescope/telescope.nvim.git",         name = "telescope.nvim",    version = "v0.2.2" },
  { src = "https://github.com/dahu/vim-fanfingtastic.git",                name = "vim-fanfingtastic", version = "master" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", version = "main" },
}, { confirm = false })
