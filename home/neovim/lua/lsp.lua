local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
local util = lspconfig.util

-- Needed for the Lua LSP to understand the Neovim API
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

-- Add nvim-cmp to capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- All servers are installed by Nix
local servers = {
  { name = 'bashls', opts = { filetypes = { 'sh', 'zsh' } } },
  { name = 'cssls', opts = {} },
  { name = 'gopls', opts = {} },
  { name = 'html', opts = {} },
  { name = 'pyright', opts = {} },
  { name = 'rnix', opts = {} },
  { name = 'rust_analyzer', opts = {} },
  { name = 'jsonls', opts = {
      commands = {
        Format = {
          function()
            vim.lsp.buf.range_formatting({}, {0, 0}, {vim.fn.line('$'), 0})
          end
        }
      }
    }
  },
  { name = 'sumneko_lua', opts = {
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Setup your lua path
            path = runtime_path,
          },
          -- Get the language server to recognize the `vim` global
          diagnostics = { globals = {'vim'} },
          -- Make the server aware of Neovim runtime files
          workspace = { library = vim.api.nvim_get_runtime_file('', true) },
          -- Disable telemetry
          telemetry = { enable = false },
        },
      },
    }
  },
}

-- Load all setups
for _, server in ipairs(servers) do
  -- Default setup
  local setup = {
    capabilities = capabilities,
  }

  -- Merge opts with default setup
  for k,v in pairs(server.opts) do setup[k] = v end

  lspconfig[server.name].setup(setup)
end
