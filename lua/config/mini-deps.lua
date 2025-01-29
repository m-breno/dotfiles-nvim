--        _      _      _
--  _ __ (_)_ _ (_)  __| |___ _ __ ___
-- | '  \| | ' \| |_/ _` / -_) '_ (_-<
-- |_|_|_|_|_||_|_(_)__,_\___| .__/__/
--                           |_|


-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'

local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = { 'git', 'clone', '--filter=blob:none', 'https://github.com/echasnovski/mini.nvim', mini_path }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

--          __          _
--    ___  / /_ _____ _(_)__  ___
--   / _ \/ / // / _ `/ / _ \(_-<
--  / .__/_/\_,_/\_, /_/_//_/___/
-- /_/          /___/

-- Use 'mini.deps'. `now()` and `later()` are helpers for a safe two-stage
-- startup and are optional.

---@diagnostic disable-next-line: undefined-global
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- # UI

now(function() add({ source = 'sainnhe/gruvbox-material', })
  vim.g.gruvbox_material_enable_italic = false
  vim.g.gruvbox_material_background = "hard"
  vim.cmd("colorscheme gruvbox-material")
end )

now(function()
  require('mini.basics').setup({
    options = {
      extra_ui = true,
    },
    mappings = {
      basic = true,

      option_toggle_prefix = [[ ]],

      windows = true,
      move_with_alt = false,
    },
    autocommands = {
      relnum_in_visual_mode = true,
    },
  })
end)
now(function()
  require('mini.notify').setup()
  vim.notify = require('mini.notify').make_notify()
end)
now(function() require('mini.icons').setup() end)
now(function() require('mini.extra').setup() end)
now(function() require('mini.tabline').setup() end)
now(function() require('mini.statusline').setup() end) -- TODO: configure s-line
now(function() require('mini.animate').setup() end)
now(function() require('mini.clue').setup() end)
now(function() require('mini.completion').setup({
   lsp_completion = {
     source_func = 'omnifunc',
   }
}) end)
now(function() require('mini.cursorword').setup() end)
now(function() require('mini.files').setup() end)
now(function() require('mini.map').setup() end)
now(function() require('mini.sessions').setup({
  autoread = false,
}) end)
--now(function() require('mini.starter').setup() end)

-- # Code
later(function() require('mini.ai').setup() end)
later(function() require('mini.align').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.pick').setup() end)
later(function() require('mini.surround').setup() end)
later(function() require('mini.comment').setup() end)
later(function() require('mini.diff').setup() end)
later(function() require('mini.fuzzy').setup() end)
later(function() require('mini.git').setup() end)
later(function() require('mini.hipatterns').setup({
  highlighters = {
    fixme = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
    hack  = { pattern = '%f[%w]()HACK()%f[%W]',  group = 'MiniHipatternsHack'  },
    todo  = { pattern = '%f[%w]()TODO()%f[%W]',  group = 'MiniHipatternsTodo'  },
    note  = { pattern = '%f[%w]()NOTE()%f[%W]',  group = 'MiniHipatternsNote'  },

    hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
  },
}) end)
later(function() require('mini.indentscope').setup() end)
later(function() require('mini.move').setup() end)
later(function() require('mini.pairs').setup() end)
later(function() require('mini.pick').setup() end)
later(function() require('mini.splitjoin').setup() end)
later(function() require('mini.trailspace').setup() end)
--later(function() require('mini.visits').setup() end)

now(function()
  -- Use other plugins with `add()`. It ensures plugin is available in current
  -- session (installs if absent)
  add({
    source = 'neovim/nvim-lspconfig',
    -- Supply dependencies near target plugin
    depends = { 'williamboman/mason.nvim' },
  })
end)

later(function()
  add({
    source = 'nvim-treesitter/nvim-treesitter',
    -- Use 'master' while monitoring updates in 'main'
    checkout = 'master',
    monitor = 'main',
    -- Perform action after every checkout
    hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
  })
  -- Possible to immediately execute code which depends on the added plugin
  require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'vimdoc' },
    highlight = { enable = true },
  })
end)

later(function() add({ source = 'andweeb/presence.nvim', }) end )
