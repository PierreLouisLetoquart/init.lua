return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = { 
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')

    -- Global setup
    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
            ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    -- Extensions
    telescope.load_extension('fzf')

    -- Keybindings
    local builtin = require('telescope.builtin')

    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Fuzzy find files in current directory' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Find string in current directory' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Fuzzy find buffers' })
  end,
}
