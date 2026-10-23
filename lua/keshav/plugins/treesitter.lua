local group = vim.api.nvim_create_augroup("TreesitterConfig", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      -- Disable LSP semantic colors.
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

local treesitter = require("nvim-treesitter")
treesitter.setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

-- Markdown and markdown_inline also render LSP hover documentation.
local installation = treesitter.install({
  "vimdoc",
  "javascript",
  "typescript",
  "tsx",
  "c",
  "lua",
  "rust",
  "go",
  "jsdoc",
  "bash",
  "python",
  "toml",
  "terraform",
  "yaml",
  "markdown",
  "markdown_inline",
})

vim.api.nvim_create_autocmd("FileType", {
  group = group,
  callback = function(args)
    local filetype = vim.bo[args.buf].filetype

    -- Skip files above 100 KB to prevent slow downs
    local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(args.buf))
    if stats and stats.size > 100 * 1024 then
      vim.treesitter.stop(args.buf)
      return
    end

    local language = vim.treesitter.language.get_lang(filetype)
    if not language then return end
    local ok, loaded = pcall(vim.treesitter.language.add, language)
    if not ok or not loaded then return end

    vim.treesitter.start(args.buf, language)
  end,
})

-- Templ is provided by the current parser registry; no custom definition needed.
vim.treesitter.language.register("templ", "templ")

return { installation = installation }
