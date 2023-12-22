HOME = os.getenv("HOME")

--=================--
-- vim settings
--=================--

-- general config
vim.g.mapleader = ' '                             -- leader key is space
vim.g.maplocalleader = '\\'                       -- local leader key is space

-- line numbers
vim.o.relativenumber = true                       -- show relative line numbers
vim.o.number = true                               -- show line numbers

-- general options
vim.o.termguicolors = true                        -- enable 24-bit rgb colors to highlight groups
vim.o.nocompatible = true                         -- don't load any default settings
vim.o.inccommand = 'nosplit'                      -- show live preview of substitutions
vim.o.updatetime = 300                            -- faster completion
vim.o.autoindent = true                           -- copy indent from current line
vim.o.timeoutlen = 300                            -- time to wait for a mapped sequence to complete (in milliseconds)
vim.o.encoding = 'utf-8'                          -- the encoding displayed
vim.o.scroloff = 2                                -- lines of context
vim.o.noshowmode = true                           -- we don't need to see things like -- INSERT -- anymore
vim.o.hidden = true                               -- enable modified buffers in background
vim.o.wrap = false				                        -- disable line wrap
vim.o.nojoinspaces = true                         -- no double spaces with join after a dot
vim.o.signcolumn = 'yes'                          -- always show the signcolumn, otherwise it would shift the text each time
vim.o.nobackup = true                             -- this is recommended by coc
vim.o.nowritebackup = true                        -- this is recommended by coc
vim.o.cursorline = true                           -- enable highlighting of the current line
vim.o.guifont = 'JetBrainsMono\\ Nerd\\ Font:h26' -- the font used in graphical neovim applications
vim.o.backspace = 'indent,eol,start'              -- make backspace in insert mode more sensible
vim.o.guicursor = 'n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor'

-- sane splis
vim.o.splitright = true                           -- horizontal splits will automatically be below
vim.o.splitbelow = true                           -- vertical splits will automatically be to the right

-- permanent undo
vim.o.undofile = true                             -- enable persistent undo
vim.o.undodir = HOME .. '/.vimdid'                -- set undo directory

-- decent wildmenu
vim.o.wildmenu = true                             -- enable wildmenu
vim.o.wildmode = 'list:longest'                   -- command-line completion mode
vim.o.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor'

-- use wide tabs (disabled until I understand how to use them)
-- vim.o.shiftwidth = 8                              -- size of an indent
-- vim.o.softtabstop = 8                             -- number of spaces that a <Tab> counts for while performing editing operations
-- vim.o.tabstop = 8                                 -- number of spaces tabs count for
vim.o.noexpandtab = true                          -- tabs are spaces
vim.o.smarttab = true                             -- makes tabbing smarter will realize you have 2 vs 8

-- Wrapping options
vim.opt.formatoptions:append('tc')                -- wrap text and comments using textwidth
vim.opt.formatoptions:append('r')                 -- continue comments when pressing ENTER in I mode
vim.opt.formatoptions:append('q')                 -- enable formatting of comments with gq
vim.opt.formatoptions:append('n')                 -- detect lists for formatting
vim.opt.formatoptions:append('b')                 -- auto-wrap in insert mode, and do not wrap old long lines

-- Proper search
vim.opt.incsearch = true                         -- show search matches as you type
vim.opt.ignorecase = true                        -- ignore case when searching
vim.opt.smartcase = true                         -- override ignorecase if search term contains uppercase characters
vim.opt.gdefault = true                          -- override ignorecase if search term contains uppercase characters

-- additional settings
vim.cmd.colorscheme('nightfox')                   -- set colorscheme
vim.cmd.syntax = 'on'                             -- enable syntax highlighting
vim.cmd('hi Normal ctermbg=NONE')                 -- set transparent background
vim.cmd('filetype plugin indent on')              -- enable filetype detection

-- uses system clipboard
vim.o.clipboard = vim.o.clipboard .. "unnamedplus"

-- disable paste mode on leaving insert mode
vim.api.nvim_exec([[autocmd InsertLeave * set nopaste]], false)

-- assists filetype detection
vim.api.nvim_exec([[autocmd BufRead *.md set filetype=markdown]], false)

-- file type tab configuration
vim.api.nvim_exec([[
  autocmd FileType typescript setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType typescriptreact setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType rust setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType lua setlocal ts=2 sts=2 sw=2 expandtab
]], false)

-- jmp to last edit position on opening file
if vim.fn.has("autocmd") == 1 then
  vim.api.nvim_exec([[
    augroup GotoLastPos
      autocmd!
      autocmd BufReadPost *
            \ if expand('%:p') !~# '\m/\.git/' &&
            \ line("'\"") > 1 && line("'\"") <= line("$") |
            \   execute "normal! g`\"" |
            \ endif
    augroup END
  ]], false)
end

--=================--
-- plugin settings
--=================--

-- nvim tree
vim.g.loaded_netrw = 1                                        -- disable netrw suggested by nvim-tree
vim.g.loaded_netrwPlugin = 1
vim.g.nvim_tree_ignore = { ".git", "node_modules", ".cache" }

-- vim-matchup
-- vim.g.matchup_matchparen_offscreen = { method = 'popup' }     -- show matching paren in popup
vim.g.matchup_matchparen_deferred = 1                         -- show matching paren after 1 second
vim.g.matchup_surround_enabled = 1                            -- enable % to match surrounding tags


-- where copilot will find node.js (needs 16)
-- vim.g.copilot_node_command = '/opt/homebrew/bin/node'
local handle = io.popen('rtx where nodejs@16')
local result = handle:read('*a')
handle:close()
vim.g.copilot_node_command = result:gsub('%s+', '') .. '/bin/node'

-- uses rg
vim.g.grepprg = 'rg --vimgrep --no-heading --smart-case --hidden --follow --glob "!.git/*"'
vim.g.grepformat = '%f:%l:%c:%m'

-- secure modelines
vim.g.secure_modelines_allowed_items = {
  "textwidth",   "tw",
  "softtabstop", "sts",
  "tabstop",     "ts",
  "shiftwidth",  "sw",
  "expandtab",   "et",   "noexpandtab", "noet",
  "filetype",    "ft",
  "foldmethod",  "fdm",
  "readonly",    "ro",   "noreadonly", "noro",
  "rightleft",   "rl",   "norightleft", "norl",
  "colorcolumn"
}

-- how lightline will be displayed
vim.g.lightline = {
  active = {
    left = { { 'mode', 'paste' },
             { 'readonly', 'filename', 'modified' } },
    right = { { 'lineinfo' },
              { 'percent' },
              { 'fileformat', 'fileencoding', 'filetype' } }
  }
  -- component_function = {
    -- filename = 'LightlineFilename'
    -- gitbranch = 'fugitive#head',
    -- lineinfo = 'lightline#bufferline#linenr',
    -- modified = 'lightline#bufferline#modified',
    -- readonly = 'lightline#bufferline#readonly',
  -- },
}

