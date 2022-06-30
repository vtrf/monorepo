local M = {}

-- From: https://github.com/mcauley-penney/tidy.nvim
function M.buf_trim_whitespace()
    -- get tuple of cursor position before making changes
    local pos = vim.api.nvim_win_get_cursor(0)

    -- delete all whitespace, see source 1
    vim.cmd([[:keepjumps keeppatterns %s/\s\+$//e]])

    -- delete all lines at end of buffer, see source 2
    vim.cmd([[:keepjumps keeppatterns silent! 0;/^\%(\n*.\)\@!/,$d]])

    -- get row count after line deletion
    local end_row = vim.api.nvim_buf_line_count(0)

    --[[
        if the row value in the original cursor
        position tuple is greater than the
        line count after empty line deletion
        (meaning that the cursor was inside of
        the group of empty lines at the end of
        the file when they were deleted), set
        the cursor row to the last line
    ]]
    if pos[1] > end_row then
        pos[1] = end_row
    end

    vim.api.nvim_win_set_cursor(0, pos)
end

function M.run_check()
  local cmds = {
    rust = { 'cargo', 'check' },
    nix = { 'nix', 'flake', 'check' },
  }

  local cmd = cmds[vim.bo.filetype]
  if cmd ~= nil then
    require('FTerm').scratch{ cmd = cmd }
  end
end

function M.augroup(name, cmds)
  vim.cmd('augroup ' .. name)
  vim.cmd('autocmd!')
  for _, cmd in ipairs(cmds) do
    vim.cmd('autocmd ' .. cmd)
  end
  vim.cmd('augroup END')
end

return M
