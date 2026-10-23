require("conform").setup({
    formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
    },
})

local cmp = require("cmp")
local capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
)

require("fidget").setup({})
require("mason").setup({})
require("mason-tool-installer").setup({
    ensure_installed = {
        "lua-language-server",
        "rust-analyzer",
        "gopls",
        "css-lsp",
        "buf",
        "ruff",
        "terraform-ls",
        "ty",
        -- Match the installed Zig 0.15 toolchain.
        { "zls", version = "0.15.1" },
    },
    auto_update = false,
    integrations = {
        ["mason-lspconfig"] = false,
        ["mason-null-ls"] = false,
        ["mason-nvim-dap"] = false,
    },
})

vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
        { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml" },
        "lua",
        ".git",
    },
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = { "?.lua", "?/init.lua", "lua/?.lua", "lua/?/init.lua" },
            },
            diagnostics = {
                globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
            },
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
            },
        },
    },
})
vim.lsp.enable("lua_ls")

vim.lsp.config("tsc", {
    cmd = function(dispatchers, config)
        local cmd = vim.fs.joinpath(config.root_dir, "node_modules", ".bin", "tsc")
        return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers)
    end,
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    root_markers = { { "tsconfig.json", "jsconfig.json", "package.json" }, ".git" },
    capabilities = capabilities,
})
vim.lsp.enable("tsc")

vim.lsp.config("cssls", {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    root_markers = { "package.json", ".git" },
    init_options = { provideFormatter = true },
    settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
    },
    capabilities = capabilities,
})
vim.lsp.enable("cssls")

vim.lsp.config("gopls", {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.work", "go.mod" },
    capabilities = capabilities,
})
vim.lsp.enable("gopls")

local rust_analyzer_cmd = vim.fn.exepath("rust-analyzer")
if rust_analyzer_cmd == "" then
    rust_analyzer_cmd = vim.fn.stdpath("data") .. "/mason/bin/rust-analyzer"
end

vim.lsp.config("rust_analyzer", {
    cmd = { rust_analyzer_cmd },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "rust-project.json" },
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true,
            },
        },
    },
    before_init = function(params, config)
        params.initializationOptions = config.settings["rust-analyzer"]
    end,
    capabilities = capabilities,
})
vim.lsp.enable("rust_analyzer")

vim.lsp.config("terraformls", {
    cmd = { "terraform-ls", "serve" },
    filetypes = { "terraform", "terraform-vars", "hcl" },
    root_markers = { ".terraform", ".terraform.lock.hcl", "terragrunt.hcl" },
    workspace_required = false,
    capabilities = capabilities,
    init_options = {
        ignoreSingleFileWarning = true,
    },
})
vim.lsp.enable("terraformls")

vim.lsp.config("buf_ls", {
    cmd = { "buf", "lsp", "serve" },
    filetypes = { "proto" },
    root_markers = { "buf.work.yaml", "buf.yaml" },
    capabilities = capabilities,
})
vim.lsp.enable("buf_ls")

vim.lsp.config("ty", {
    cmd = { "uv", "run", "ty", "server" },
    filetypes = { "python" },
    root_markers = { "ty.toml", "uv.lock" },
    settings = {
        ty = {},
    },
    capabilities = capabilities,
})
vim.lsp.enable("ty")

vim.lsp.config("zls", {
    cmd = { "zls" },
    filetypes = { "zig", "zir" },
    root_markers = { "build.zig", "zls.json", ".git" },
    settings = {
        zls = {
            enable_inlay_hints = true,
            enable_snippets = true,
            warn_style = true,
        },
    },
    capabilities = capabilities,
})
vim.lsp.enable("zls")
vim.g.zig_fmt_parse_errors = 0
vim.g.zig_fmt_autosave = 0

-- Ruff is used by Conform; ty provides Python language features.
-- Neither the Ruff nor the basedpyright language server is enabled.

local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<Tab>"] = cmp.mapping.select_next_item(cmp_select),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        }),
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
    }, {
        { name = "buffer" },
    }),
})

vim.diagnostic.config({
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})
