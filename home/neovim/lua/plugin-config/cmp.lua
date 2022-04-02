vim.o.completeopt = 'menuone,noselect'
vim.g.completion_matching_strategy = { 'exact', 'substring', 'fuzzy' }

local cmp = require('cmp')

require('cmp').setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
  },
  sources = cmp.config.sources({
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'cmdline' },
    { name = 'nvim_lua' },
    { name = 'emoji' },
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
  })
})
