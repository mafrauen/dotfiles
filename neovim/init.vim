scriptencoding utf-8
set encoding=utf-8
set nocompatible                " choose no compatibility with legacy vi
filetype off

set runtimepath+=~/.vim,~/.vim/after
set packpath+=~/.vim

call plug#begin('~/.nvvim/plugged')

" Languages
Plug 'pangloss/vim-javascript'
Plug 'HerringtonDarkholme/yats.vim'

Plug 'hail2u/vim-css3-syntax'
Plug 'vim-python/python-syntax'
Plug 'vim-scripts/indentpython.vim'
Plug 'tweekmonster/django-plus.vim'
Plug 'mitsuhiko/vim-jinja'

Plug 'groenewege/vim-less'
Plug 'juvenn/mustache.vim'

Plug 'dense-analysis/ale'
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'Lokaltog/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'tomtom/tcomment_vim'
Plug 'jiangmiao/auto-pairs'
Plug 'ludovicchabant/vim-gutentags'

" Colors
Plug 'chriskempson/vim-tomorrow-theme'

call plug#end()

" nmap <D-]> :tabnext<CR>
" nmap <D-[> :tabprevious<CR>

filetype plugin indent on       " load file type plugins + indentation

syntax enable
" set showcmd                     " display incomplete commands
" set relativenumber
set number
set colorcolumn=80
" set synmaxcol=400
set autoindent
set smartindent
set smarttab

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2 shiftwidth=2      " a tab is two spaces (or set this to 4)
set expandtab                   " use spaces, not tabs (optional)
set backspace=indent,eol,start  " backspace through everything in insert mode
set diffopt=filler,vertical

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

set ruler
set clipboard=unnamed
set laststatus=2

set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.
set conceallevel=1

set formatoptions+=j " Delete comment character when joining commented lines

if has("gui_running")
  set guioptions-=T
  set guioptions-=r
  set guioptions-=L
  set guifont=Source\ Code\ Pro:h20
endif

set background=dark
colorscheme Tomorrow-Night

set backupdir=/var/tmp/vimr
set directory=/var/tmp/vimr
set wildignore+=*.pyc " ignore compiled python
let g:netrw_list_hide= '\.pyc$'

let mapleader = ","
let g:mapleader = ","

" turn off highlighting
nnoremap <leader><space> :noh<cr>

" Used with matchit to go to next paren, etc.
map <tab> %
vmap <tab> %
vnoremap <tab> %

noremap H ^
noremap L $
vnoremap L g_

" Move windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>c :ccl \| pc<CR>

nnoremap <Leader>j :call IssueKey()<CR>
function! IssueKey()
  let key = system("git symbolic-ref HEAD | awk 'match($0, /[A-Z]+-[0-9]+/) { printf \"%s\",substr($0, RSTART, RLENGTH) }'")
  call setline(line('.'), getline('.').'['.key.'] ')
endfunction

" " Colors
" Blue
hi typescriptVariable ctermfg=110
hi typescriptExport ctermfg=110
hi typescriptImport ctermfg=110

" Purple
hi typescriptAliasDeclaration ctermfg=139
hi typescriptTypeReference ctermfg=139
hi typescriptTypeParameter ctermfg=139
hi typescriptPredefinedType ctermfg=139

" Yellow
hi typescriptArrowFuncArg ctermfg=yellow

" Hilight test
" :so $VIMRUNTIME/syntax/hitest.vim

" Easymotion
let g:EasyMotion_smartcase = 1
" map \ <Plug>(easymotion-sn)
map <leader>\ <Plug>(easymotion-sn)

" javascript
let g:javascript_conceal = 1
let g:javascript_conceal_function = "ƒ"
let g:javascript_conceal_prototype = "¶"
let g:javascript_conceal_arrow_function = "⍄"
let g:javascript_plugin_flow = 1
autocmd BufRead,BufNewFile *.js,*.ts,*.tsx :iab log console.log()<Left>

" django
autocmd BufRead,BufNewFile *.html,.jinja :iab tt {{}}<Left><Left>
autocmd BufRead,BufNewFile *.html,.jinja :iab vv {%%}<Left><Left>

" Fugitive
nnoremap <leader>s :Gstatus<cr>

" Tags
let g:gutentags_file_list_command = 'rg --files'

" python
nnoremap <leader>F :e /Users/mfrauenholtz/.virtualenvs/bb/lib/python2.7/site-packages/<CR>

" FZF
nmap <leader>f :GFiles<CR>
nmap <leader>t :Tags<CR>
nmap <leader>T :BTags<CR>
nmap ; :Buffers<CR>
nmap <leader>l :Lines<CR>
" nmap <space> :BLines<CR>
nmap \ :BLines<CR>
nmap <leader>b :Lines<CR>
nmap <leader>h :History<CR>
set grepprg=rg\ --vimgrep\ --no-heading
set grepformat=%f:%l:%c:%m,%f:%l:%m
set grepprg=rg\ --vimgrep
command! -nargs=+ -bar Find silent! grep! <args>|cwindow|redraw!

" ALE
let g:ale_linters = {}
let g:ale_fixers = {}

let g:ale_linters.javascript = ['eslint']
let g:ale_linters.javascriptreact = ['eslint']
let g:ale_linters.typescript = ['eslint', 'tsserver']
let g:ale_linters.typescriptreact = ['eslint', 'tsserver']
let g:ale_linters.python = ['pyflakes', 'flake8', 'pyls']

let g:ale_fixers.javascript = ['prettier']
let g:ale_fixers.typescript = ['prettier']
let g:ale_fixers.typescriptreact = ['prettier']
let g:ale_fix_on_save = 1

nmap <leader>g <Plug>(ale_go_to_definition)
nmap K <Plug>(ale_hover)

" Use ALE's function for omnicompletion.
set omnifunc=ale#completion#OmniFunc
let g:ale_completion_enabled = 1
" Hide preview while completing
set completeopt-=preview

let g:python_host_prog = '/Users/mfrauenholtz/.virtualenvs/bb/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'
let g:python_highlight_all = 1
