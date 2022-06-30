-- Telescope configuration
local telescope = require('telescope')
local sorters = require('telescope.sorters')

telescope.load_extension('fzy_native')

telescope.setup {
  defaults = { file_sorter = sorters.get_fzy_sorter },
  extensions = {
    fzy_native = { override_generic_sorter = false, override_file_sorter = true }
  },
}
