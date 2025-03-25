return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "stevearc/conform.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },

  config = function()
    require("conform").setup({
      formatters_by_ft = {
      }
    })
    local cmp = require('cmp')
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities())

    require("fidget").setup({})
    require("mason").setup({
      ensure_installed = {
        "debugpy",
      }
    })
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "ts_ls",
        "cssls",
        "basedpyright",
        "ruff"
      },
      automatic_installation = true,
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities
          }
        end,

        zls = function()
          local lspconfig = require("lspconfig")
          lspconfig.zls.setup({
            root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
            settings = {
              zls = {
                enable_inlay_hints = true,
                enable_snippets = true,
                warn_style = true,
              },
            },
          })
          vim.g.zig_fmt_parse_errors = 0
          vim.g.zig_fmt_autosave = 0
        end,
        ["ruff"] = function()
          require("lspconfig").ruff.setup {
            init_options = {
              settings = {
                args = {},
              }
            },
            commands = {
              RuffAutofix = {
                function()
                  vim.lsp.buf.execute_command {
                    command = 'ruff.applyAutofix',
                    arguments = {
                      { uri = vim.uri_from_bufnr(0) },
                    },
                  }
                end,
                description = 'Ruff: Fix all auto-fixable problems',
              }
            }
          }
        end,
        basedpyright = function()
          require("lspconfig").basedpyright.setup {
            settings = {
              basedpyright = {
                analysis = {
                  diagnosticMode = "openFilesOnly",
                  inlayHints = {
                    callArgumentNames = true,
                    variableTypes = true, -- reportMissingTypeStubs
                    functionReturnTypes = true
                  }
                }
              }
            }
          }
        end,
        ["lua_ls"] = function()
          require("lspconfig").lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                }
              }
            }
          }
        end
      }
    })

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = {
        ['<S-Tab>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<Tab>'] = cmp.mapping.select_next_item(cmp_select),
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true
        }),
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
      }, {
        { name = 'buffer' },
      })
    })

    vim.diagnostic.config({
      -- update_in_insert = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end
}
