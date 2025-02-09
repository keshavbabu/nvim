return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require('gitsigns').setup {
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- navigate changes
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gitsigns.nav_hunk('next')
          end
        end) -- next change
        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gitsigns.nav_hunk('prev')
          end
        end)                                                             -- prev change
        map('n', '<leader>gq', function() gitsigns.setqflist('all') end) -- nav menu of changes in project

        -- git add
        map('v', '<leader>gs', function()
          gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)                                          -- stage the selected region
        map('n', '<leader>gs', gitsigns.stage_hunk)   -- stage current line
        map('n', '<leader>gS', gitsigns.stage_buffer) -- stage entire buffer

        -- git restore
        map('v', '<leader>gr', function()
          gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end)                                          -- restores the selected region
        map('n', '<leader>gr', gitsigns.reset_hunk)   -- restores the current line
        map('n', '<leader>gR', gitsigns.reset_buffer) -- restores entire buffer

        -- git diff
        map('n', '<leader>gd', gitsigns.diffthis) -- diff entire buffer

        -- git blame
        map('n', '<leader>gb', function()
          gitsigns.blame_line({ full = true })
        end)                                 -- blame the current line
        gitsigns.toggle_current_line_blame() -- enable line blame by default
      end
    }
  end
}
