-- Highlight todo, notes, etc in comments
return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  config = function()
    require("todo-comments").setup {
      signs = false
    }

  end
}
