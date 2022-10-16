" Fish doesn't play all that well with others
set shell=/bin/zsh
let mapleader = "\<Space>"

" =============================================================================
" # PLUGINS
" =============================================================================
" Load vundle
set nocompatible
filetype off
" set rtp+=~/dev/others/base16/templates/vim/
call plug#begin()

" Nightfox theme
Plug 'EdenEast/nightfox.nvim', {'branch': 'main'}

" VIM enhancements
Plug 'ciaranm/securemodelines'
Plug 'editorconfig/editorconfig-vim'
Plug 'ggandor/leap.nvim', {'branch': 'main'}
Plug 'numToStr/Comment.nvim'
Plug 'mg979/vim-visual-multi', {'branch': 'master'} " multi cursor
" Plug 'justinmk/vim-sneak'

" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Semantic language support
" Plug 'neovim/nvim-lspconfigs
" Plug 'nvim-lua/lsp_extensions.nvim'
" Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main'}
" Plug 'hrsh7th/cmp-buffer', {'branch': 'main'}
" Plug 'hrsh7th/cmp-path', {'branch': 'main'}
" Plug 'hrsh7th/nvim-cmp', {'branch': 'main'}
" Plug 'ray-x/lsp_signature.nvim'
Plug 'nvim-treesitter/nvim-treesitter'

" File pickers
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'nvim-telescope/telescope-file-browser.nvim'

" Javascript support
Plug 'jose-elias-alvarez/null-ls.nvim'

" Only because nvim-cmp _requires_ snippets
" Plug 'hrsh7th/cmp-vsnip', {'branch': 'main'}
" Plug 'hrsh7th/vim-vsnip'

" Syntactic language support
Plug 'cespare/vim-toml', {'branch': 'main'}
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'rhysd/vim-clang-format'
"Plug 'fatih/vim-go'
"Plug 'dag/vim-fish'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

call plug#end()

if has('nvim')
    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
    set inccommand=nosplit
    noremap <C-q> :confirm qall<CR>
end

" Theme and Colors
colorscheme nightfox
syntax on
hi Normal ctermbg=NONE

" LSP configuration
" lua << END
" local cmp = require'cmp'

" local lspconfig = require'lspconfig'
" cmp.setup({
"   snippet = {
"     -- REQUIRED by nvim-cmp. get rid of it once we can
"     expand = function(args)
"       vim.fn["vsnip#anonymous"](args.body)
"     end,
"   },
"   mapping = {
"     -- Tab immediately completes. C-n/C-p to select.
"     ['<Tab>'] = cmp.mapping.confirm({ select = true })
"   },
"   sources = cmp.config.sources({
"     -- TODO: currently snippets from lsp end up getting prioritized -- stop that!
"     { name = 'nvim_lsp' },
"   }, {
"     { name = 'path' },
"   }),
"   experimental = {
"     ghost_text = true,
"   },
" })

" -- Enable completing paths in :
" cmp.setup.cmdline(':', {
"   sources = cmp.config.sources({
"     { name = 'path' }
"   })
" })

" -- Setup lspconfig.
" local on_attach = function(client, bufnr)
"   local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
"   local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

"   --Enable completion triggered by <c-x><c-o>
"   buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

"   -- Mappings.
"   local opts = { noremap=true, silent=true }

"   -- See `:help vim.lsp.*` for documentation on any of the below functions
"   buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
"   buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
"   buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
"   buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
"   buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
"   buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
"   buf_set_keymap('n', '<space>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
"   buf_set_keymap('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
"   buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
"   buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
"   buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
"   buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
"   buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.set_loclist()<CR>', opts)
"   buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

"   -- Get signatures (and _only_ signatures) when in argument lists.
"   require "lsp_signature".on_attach({
"     doc_lines = 0,
"     handler_opts = {
"       border = "none"
"     },
"   })
" end

" local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
" lspconfig.rust_analyzer.setup {
"   on_attach = on_attach,
"   flags = {
"     debounce_text_changes = 150,
"   },
"   settings = {
"     ["rust-analyzer"] = {
"       cargo = {
"         allFeatures = true,
"       },
"       completion = {
" 	postfix = {
" 	  enable = false,
" 	},
"       },
"     },
"   },
"   capabilities = capabilities,
" }

" vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
"   vim.lsp.diagnostic.on_publish_diagnostics, {
"     virtual_text = true,
"     signs = true,
"     update_in_insert = true,
"   }
" )
" END

" Enable type inlay hints
" autocmd CursorHold,CursorHoldI *.rs :lua require'lsp_extensions'.inlay_hints{ only_current_line = true }

" Plugin settings
let g:secure_modelines_allowed_items = [
                \ "textwidth",   "tw",
                \ "softtabstop", "sts",
                \ "tabstop",     "ts",
                \ "shiftwidth",  "sw",
                \ "expandtab",   "et",   "noexpandtab", "noet",
                \ "filetype",    "ft",
                \ "foldmethod",  "fdm",
                \ "readonly",    "ro",   "noreadonly", "noro",
                \ "rightleft",   "rl",   "norightleft", "norl",
                \ "colorcolumn"
                \ ]

" Lightline
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileencoding', 'filetype' ] ],
      \ },
      \ 'component_function': {
      \   'filename': 'LightlineFilename'
      \ },
      \ }
function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

" Copilot
let g:copilot_node_command =
      \ "~/.nvm/versions/node/v16.17.0/bin/node"

" from http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
if executable('ag')
	set grepprg=ag\ --nogroup\ --nocolor
endif
if executable('rg')
	set grepprg=rg\ --no-heading\ --vimgrep
	set grepformat=%f:%l:%c:%m
endif

" Javascript
let javaScript_fold=0

" Java
let java_ignore_javadoc=1

" Latex
let g:latex_indent_enabled = 1
let g:latex_fold_envs = 0
let g:latex_fold_sections = []

" Open hotkeys
map <C-p> :Files<CR>
nmap <leader>; :Buffers<CR>

" Quick-save
nmap <leader>w :w<CR>

" Don't confirm .lvimrc
let g:localvimrc_ask = 0

" rust
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_clip_command = 'xclip -selection clipboard'

" Completion
" Better completion
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" Golang
let g:go_play_open_browser = 0
let g:go_fmt_fail_silently = 1
let g:go_fmt_command = "goimports"
let g:go_bin_path = expand("~/dev/go/bin")

" =============================================================================
" # Editor settings
" =============================================================================
filetype plugin indent on
set autoindent
set timeoutlen=300 " http://stackoverflow.com/questions/2158516/delay-before-o-opens-a-new-line
set encoding=utf-8
set scrolloff=2
set noshowmode
set hidden
set nowrap
set nojoinspaces
let g:sneak#s_next = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_frontmatter = 1
set printfont=:h10
set printencoding=utf-8
set printoptions=paper:letter
" Always draw sign column. Prevent buffer moving when adding/deleting sign.
set signcolumn=yes
" Disable backups as per coc.nvim recommendation - https://github.com/neoclide/coc.nvim
set nobackup
set nowritebackup
" Highlight current line
set cursorline

" Settings needed for .lvimrc
" set exrc
" set secure

" Sane splits
set splitright
set splitbelow

" Permanent undo
set undodir=~/.vimdid
set undofile

" Decent wildmenu
set wildmenu
set wildmode=list:longest
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor

" Use wide tabs
set shiftwidth=8
set softtabstop=8
set tabstop=8
set noexpandtab

" Wrapping options
set formatoptions=tc " wrap text and comments using textwidth
set formatoptions+=r " continue comments when pressing ENTER in I mode
set formatoptions+=q " enable formatting of comments with gq
set formatoptions+=n " detect lists for formatting
set formatoptions+=b " auto-wrap in insert mode, and do not wrap old long lines

" Proper search
set incsearch
set ignorecase
set smartcase
set gdefault

" Search results centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" ==========================================================  coc.nvim settings

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <BS>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" Redo with U instead of Ctrl+R
nnoremap <silent> U :redo<CR>

" ==========================================================  coc.nvim settings


" Very magic by default
" nnoremap ? ?\v
" nnoremap / /\v
" cnoremap %s/ %sm/

" =============================================================================
" # GUI settings
" =============================================================================
set guioptions-=T " Remove toolbar
set vb t_vb= " No more beeps
set backspace=2 " Backspace over newlines
set nofoldenable
set ttyfast
" https://github.com/vim/vim/issues/1735#issuecomment-383353563
set lazyredraw
set synmaxcol=500
set laststatus=2
set relativenumber " Relative line numbers
set number " Also show current absolute line
set diffopt+=iwhite " No whitespace in vimdiff
" Make diffing better: https://vimways.org/2018/the-power-of-diff/
set diffopt+=algorithm:patience
set diffopt+=indent-heuristic
" set colorcolumn=80 " and give me a colored column
set showcmd " Show (partial) command in status line.
set mouse=a " Enable mouse usage (all modes) in terminals
set shortmess+=c " don't give |ins-completion-menu| messages.

" Show those damn hidden characters
" Verbose: set listchars=nbsp:¬,eol:¶,extends:»,precedes:«,trail:•
set listchars=nbsp:¬,extends:»,precedes:«,trail:•

" Telescope FileBrowser
lua << EOF
-- load telescope-file-browser
require('telescope').load_extension "file_browser"
vim.api.nvim_set_keymap(
  "n",
  "<space>fs",
  ":Telescope file_browser",
  { noremap = true }
)
EOF

" =============================================================================
" # Keyboard shortcuts
" =============================================================================
" ; as :
nnoremap ; :

" Ctrl+j and Ctrl+k as Esc
" Ctrl-j is a little awkward unfortunately:
" https://github.com/neovim/neovim/issues/5916
" So we also map Ctrl+k
" nnoremap <C-j> <Esc>
" inoremap <C-j> <Esc>
" vnoremap <C-j> <Esc>
" snoremap <C-j> <Esc>
" xnoremap <C-j> <Esc>
" cnoremap <C-j> <C-c>
" onoremap <C-j> <Esc>
" lnoremap <C-j> <Esc>
" tnoremap <C-j> <Esc>

nnoremap <C-k> <Esc>
inoremap <C-k> <Esc>
vnoremap <C-k> <Esc>
snoremap <C-k> <Esc>
xnoremap <C-k> <Esc>
cnoremap <C-k> <C-c>
onoremap <C-k> <Esc>
lnoremap <C-k> <Esc>
tnoremap <C-k> <Esc>

" ]+Space in normal mode to add line below
nnoremap <silent> ]<Space> o<Esc>
" [+Space in normal mode to add line above
nnoremap <silent> [<Space> O<Esc>

" Ctrl+h to stop searching
vnoremap <C-j> :nohlsearch<cr>
nnoremap <C-j> :nohlsearch<cr>

" Suspend with Ctrl+f
" inoremap <C-f> :sus<cr>
" vnoremap <C-f> :sus<cr>
" nnoremap <C-f> :sus<cr>

" Jump to start and end of line using the home row keys
map H ^
map L $

" Telescope suggested keybindings
" Find files using Telescope command-line sugar
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fs <cmd>Telescope file_browser<cr>

" Using Lua functions
" nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
" nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
" nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
" nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

" Neat X clipboard integration
" ,p will paste clipboard into buffer
" ,c will copy entire buffer into clipboard
noremap <leader>p :read !pbpaste<cr>
noremap <leader>c :w !pbcopy<cr><cr>

" <leader>s for Rg search
noremap <leader>s :Rg
let g:fzf_layout = { 'down': '~20%' }
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

function! s:list_cmd()
  let base = fnamemodify(expand('%'), ':h:.:S')
  return base == '.' ? 'fd --type file --follow' : printf('fd --type file --follow | proximity-sort %s', shellescape(expand('%')))
endfunction

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, {'source': s:list_cmd(),
  \                               'options': '--tiebreak=index'}, <bang>0)


" Open new file adjacent to current file
nnoremap <leader>o :e <C-R>=expand("%:p:h") . "/" <CR>

" No arrow keys --- force yourself to use the home row
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Left and right can switch buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

" Move by line
nnoremap j gj
nnoremap k gk

" <leader><leader> toggles between buffers
nnoremap <leader><leader> <c-^>

" <leader>, shows/hides hidden characters
nnoremap <leader>, :set invlist<cr>

" <leader>q shows stats
nnoremap <leader>q g<c-g>

" Keymap for replacing up to next _ or -
noremap <leader>m ct_

" I can type :help on my own, thanks.
map <F1> <Esc>
imap <F1> <Esc>


" =============================================================================
" # Autocommands
" =============================================================================

" Prevent accidental writes to buffers that shouldn't be edited
" autocmd BufRead *.orig set readonly
" autocmd BufRead *.pacnew set readonly

" Leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste

" Jump to last edit position on opening file
if has("autocmd")
  " https://stackoverflow.com/questions/31449496/vim-ignore-specifc-file-in-autocommand
  au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Follow Rust code style rules
au Filetype rust source ~/.config/nvim/scripts/spacetab.vim
" au Filetype rust set colorcolumn=100

" Help filetype detection
" autocmd BufRead *.plot set filetype=gnuplot
autocmd BufRead *.md set filetype=markdown
" autocmd BufRead *.lds set filetype=ld
" autocmd BufRead *.tex set filetype=tex
" autocmd BufRead *.trm set filetype=c
" autocmd BufRead *.xlsx.axlsx set filetype=ruby

" Script plugins
autocmd Filetype html,xml,xsl,php source ~/.config/nvim/scripts/closetag.vim

" =============================================================================
" # Footer
" =============================================================================

" nvim
" if has('nvim')
" 	runtime! plugin/python_setup.vim
" endif

" Leap configuration
lua <<EOF
require('leap').set_default_keymaps()
require('Comment').setup()
EOF

" TypeScript configuration
autocmd FileType typescript setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType typescriptreact setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType json setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType rust setlocal ts=4 sts=4 sw=4 expandtab

" Terminal settings
" Disables line numbers on the terminal
autocmd TermOpen * setlocal nonumber norelativenumber
