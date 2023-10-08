return {
  'hrsh7th/nvim-cmp',
  event = 'InsertEnter',
  dependencies = {
    'hrsh7th/cmp-buffer', -- source for text in buffer
    'hrsh7th/cmp-path', -- source for file system paths
    'L3MON4D3/LuaSnip', -- snippet support
    'saadparwaiz1/cmp_luasnip', -- snippet source for LuaSnip
    'rafamadriz/friendly-snippets', -- set of usefull snippets
  },
  config = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')

    -- load vscode snippets from installed plugins (e.g. friendly-snippets)
    require('luasnip/loaders/from_vscode').lazy_load()

    cmp.setup({
      completion = {
        completeopt = 'menu,menuone,preview,noselect',
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-t>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(), -- show completion suggestions
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
      },
      -- sources for completion
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' }, -- snippets
        { name = 'buffer' }, -- text in buffer
        { name = 'path' }, -- file system paths
      },
    })
  end,
}
