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
-- now(function() require('mini.clue').setup() end)
now(function() require('mini.completion').setup({
   lsp_completion = {
     source_func = 'omnifunc',
   }
}) end)
-- now(function() require('mini.cursorword').setup() end)
now(function() require('mini.files').setup() end)
-- now(function() require('mini.map').setup() end)
-- now(function() require('mini.sessions').setup({
  -- autoread = false,
-- }) end)
--now(function() require('mini.starter').setup() end)

-- # Code
-- later(function() require('mini.ai').setup() end)
-- later(function() require('mini.align').setup() end)
later(function() require('mini.comment').setup() end)
-- later(function() require('mini.surround').setup() end)
later(function() require('mini.diff').setup() end)
-- later(function() require('mini.fuzzy').setup() end)
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
-- later(function() require('mini.pick').setup() end)
-- later(function() require('mini.splitjoin').setup() end)
later(function() require('mini.trailspace').setup() end)
--later(function() require('mini.visits').setup() end)

later(function() add({ source = 'andweeb/presence.nvim', }) end )

--    __
--   / /__ ___
--  / (_-</ _ \
-- /_/___/ .__/
--      /_/

local servers = {
  bashls = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "bash", "sh" },
    root_dir = vim.fs.root(0, '.git'),
  },
  cssls = {
    cmd = { 'vscode-css-language-server', '--stdio' },
    filetypes = { 'css', 'scss', 'less' },
    init_options = { provideFormatter = true },
    root_dir = vim.fs.root(0, {'package.json', '.git'}),
  },
  html = {
    cmd = { 'vscode-html-language-server', '--stdio' },
    filetypes = { 'html', 'templ' },
    root_dir = vim.fs.root(0, {'package.json', '.git'}),
    single_file_support = true,
    settings = {},
    init_options = {
      provideFormatter = true,
      embeddedLanguages = { css = true, javascript = true },
      configurationSection = { 'html', 'css', 'javascript' },
    }
  },
  hyprls = {
    cmd = { 'hyprls', '--stdio' },
    filetypes = { 'hyprlang' },
    root_dir = vim.fs.root(0, '.git'),
  },
  lua_ls = {
    name = "lua-language-server",
    cmd = { "lua-language-server" },
    root_dir = vim.fs.root(0, { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml", ".git" }),
    filetypes = { "lua" },
  },
  marksman = {
    cmd = { "marksman", "server"},
    filetypes = { 'markdown', 'markdown.mdx' },
    root_dir = vim.fs.root(0, '.git'),
  },
  pylsp = {
    cmd = { 'pylsp' },
    filetypes = { 'python' },
    root_dir = vim.fs.root(0, {'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile',}),
  }
}
local group = vim.api.nvim_create_augroup("UserLspStart", { clear = true })
for name, config in pairs(servers) do
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = config.filetypes,
    callback = function (ev)
      vim.lsp.start(servers[name], { bufnr = ev.buf })
    end,
  })
end

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        pcall(vim.treesitter.start)
    end
})

vim.filetype.add({
  pattern = { [".*/hypr/.*%.conf"] = "hyprlang" },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "hyprlang",
  callback = function()
    vim.bo.commentstring = "# %s"
  end
})

later(function() add({ source = 'rafamadriz/friendly-snippets', })
  -- require("luasnip.loaders.from_vscode").setup()
end)
