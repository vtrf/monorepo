local map = function(params)
    setmetatable(params, { __index = { mode = 'n', opts = { noremap = true } } })
    local from, to, mode, opts =
      params[1] or params.from,
      params[2] or params.to,
      params[3] or params.mode,
      params[4] or params.opts

    vim.api.nvim_set_keymap(mode, from, to, opts)
end

-- faster ESC
map{'jk', '<esc>l', 'i', { noremap = true, silent = true }}

-- g version of j/k for easily navigating wrapped content
map{'k', 'v:count == 0 ? "gk" : "k"', opts = { noremap = true, expr = true }}
map{'j', 'v:count == 0 ? "gj" : "j"', opts = { noremap = true, expr = true }}

-- g version of 0, ^ and $
map{'$', 'g$'}
map{'^', 'g^'}
map{'0', 'g0'}

-- Sensible undo
map{'U', '<C-r>'}

-- Sensible Y
map{'Y', 'y$'}

-- Easier tabbing of visually selected content
map{'<', '<gv', 'v'}

-- Move things in visual mode with J and K
map{'J', ":m '>+1<cr>gv=gv", 'v'}
map{'K', ":m '>-2<cr>gv=gv", 'v'}

-- Telescope
map{'<leader>hs', "<cmd>Telescope help_tags<cr>"}
map{'<leader>pf', "<cmd>Telescope find_files<cr>"}
map{'<leader>ps', "<cmd>Telescope live_grep<cr>"}
map{'<leader>pt', "<cmd>TodoTelescope<cr>"}
map{'<leader>ss', "<cmd>Telescope buffers<cr>"}
