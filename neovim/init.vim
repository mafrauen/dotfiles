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
Plug 'ianks/vim-tsx'
Plug 'hail2u/vim-css3-syntax'
" Plug 'styled-components/vim-styled-components'

Plug 'vim-python/python-syntax'
Plug 'vim-scripts/indentpython.vim'
Plug 'tweekmonster/django-plus.vim'
Plug 'mitsuhiko/vim-jinja'

Plug 'groenewege/vim-less'
Plug 'juvenn/mustache.vim'

Plug 'w0rp/ale'
Plug 'mileszs/ack.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'Lokaltog/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'tomtom/tcomment_vim'
Plug 'jiangmiao/auto-pairs'
" Plug 'alvan/vim-closetag'
Plug 'terryma/vim-multiple-cursors'
Plug 'ludovicchabant/vim-gutentags'

" Plug 'neoclide/coc.nvim', {'do': './install.sh nightly'}

" Plug 'ajh17/VimCompletesMe'
Plug 'lifepillar/vim-mucomplete'

Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Colors
Plug 'chriskempson/vim-tomorrow-theme'

call plug#end()

nmap <D-]> :tabnext<CR>
nmap <D-[> :tabprevious<CR>

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

" Colors
hi typescriptImport guifg=#81a2be ctermfg=cyan
hi typescriptVariable guifg=#81a2be ctermfg=cyan
hi typescriptExport guifg=#81a2be ctermfg=cyan
hi tsxIntrinsicTagName guifg=#81a2be ctermfg=cyan
hi tsxTag guifg=#81a2be ctermfg=cyan
hi tsxCloseTag guifg=#cc6666
hi typescriptFuncKeyword guifg=#81a2be ctermfg=cyan
hi typescriptBraces guifg=#c5c8c6
hi typescriptTypeReference guifg=#b294bb ctermfg=magenta
hi typescriptAliasDeclaration guifg=#b294bb ctermfg=magenta
hi typescriptObjectLabel guifg=#c5c8c6

" Easymotion
let g:EasyMotion_smartcase = 1
map <space> <Plug>(easymotion-sn)

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

" Close tags
let g:closetag_xhtml_filenames = '*.js'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_filenames = '*.js'


" Tags
let g:gutentags_file_list_command = 'rg --files'

" python
nnoremap <leader>F :e /Users/mfrauenholtz/.virtualenvs/bb/lib/python2.7/site-packages/<CR>


" FZF
nmap <leader>f :GFiles<CR>
nmap <leader>t :Tags<CR>
nmap ; :Buffers<CR>
nmap <leader>l :Lines<CR>
nmap \ :BLines<CR>
nmap <leader>b :Lines<CR>
nmap <leader>h :History<CR>
nmap <leader>\ :Rg 
set grepprg=rg\ --vimgrep\ --no-heading
set grepformat=%f:%l:%c:%m,%f:%l:%m
set grepprg=rg\ --vimgrep
command! -nargs=+ -bar Find silent! grep! <args>|cwindow|redraw!

" ALE
let g:ale_fix_on_save = 1
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_javascript_prettier_use_local_config = 1
let g:ale_linters = {}
let g:ale_fixers = {}
" autocmd BufRead,BufNewFile *.py let g:ale_lint_on_text_changed = 'never'

" let g:ale_linters.javascript = ['eslint', 'tsserver']
" let g:ale_linters.typescript = ['tslint', 'tsserver']
" let g:ale_linters['typescript.tsx'] = ['tslint', 'tsserver']
let g:ale_linters.python = ['pyflakes', 'flake8', 'pyls']

let g:ale_fixers.javascript = ['prettier']
let g:ale_fixers.typescript = ['prettier']
let g:ale_fixers['typescript.tsx'] = ['prettier']
" let g:ale_fixers.python = ['yapf']

" autocmd BufRead,BufNewFile *.js,*.ts,*.tsx nmap <leader>g <Plug>(ale_go_to_definition)
" autocmd BufRead,BufNewFile *.py nmap <leader>g <Plug>(coc-definition)
"
" function! s:show_documentation()
" 	if (index(['vim','help'], &filetype) >= 0)
" 		execute 'h '.expand('<cword>')
" 	else
" 		call CocAction('doHover')
" 	endif
" endfunction

" nnoremap <silent> K :call <SID>show_documentation()<CR>
" nmap <leader>g <Plug>(ale_go_to_definition)
" " nmap K <Plug>(ale_hover)
" nmap gd <Plug>(coc-definition)

let g:LanguageClient_serverCommands = {}
" let g:LanguageClient_serverCommands.javascript = ['flow', 'lsp']
let g:LanguageClient_serverCommands.typescript = ['javascript-typescript-stdio']
let g:LanguageClient_serverCommands['typescript.tsx'] = ['javascript-typescript-stdio']
" let g:LanguageClient_serverCommands['javascript.jsx'] = ['flow', 'lsp']
let g:LanguageClient_serverCommands.python = ['pyls']
"
" Turn off quickfix for LSP
" let g:LanguageClient_diagnosticsEnable = 0
nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> <leader>g :call LanguageClient_textDocument_definition()<CR>

" Completion
" let g:ale_completion_enabled = 1
" set completeopt=menu,menuone,preview,noselect,noinsert
" set completeopt-=preview
set completeopt+=longest,menuone,noselect
set completefunc=LanguageClient#complete
" let g:mucomplete#completion_delay = 1
let g:mucomplete#enable_auto_at_startup = 1

let g:python_host_prog = '/Users/mfrauenholtz/.virtualenvs/bb/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'
let g:python_highlight_all = 1







" Stop annoying diagnostics sign popups, use virtual text with prefix instead
let g:LanguageClient_diagnosticsSignsMax = 0
let g:LanguageClient_hasSnippetSupport = 1
let g:LanguageClient_useFloatingHover = 1
let g:LanguageClient_useVirtualText = 1
let g:LanguageClient_changeThrottle = 0.5
let g:LanguageClient_virtualTextPrefix = "    •••➜ "
let g:LanguageClient_diagnosticsList = "Location"
let g:LanguageClient_selectionUI = "location-list"
let g:LanguageClient_hoverpreview = "Always"

" Custom color highlight for virtual text
highlight LCErrorHighlight  ctermfg=203 guifg=#FF6E6E
highlight LCWarnHighlight   ctermfg=215 guifg=#FFB86C
highlight LCHintHighlight   ctermfg=142 guifg=#ABB2BF
highlight LCInfoHighlight   ctermfg=239 guifg=#44475A

let g:LanguageClient_diagnosticsDisplay = {
    \      1: {
    \          "name": "Error",
    \          "texthl": "Underline",
    \          "signText": "✗",
    \          "signTexthl": "LCErrorHighlight",
    \          "virtualTexthl": "LCErrorHighlight",
    \      },
    \      2: {
    \          "name": "Warning",
    \          "texthl": "",
    \          "signText": "‼",
    \          "signTexthl": "LCWarnHighlight",
    \          "virtualTexthl": "LCWarnHighlight",
    \      },
    \      3: {
    \          "name": "Information",
    \          "texthl": "",
    \          "signText": "‽",
    \          "signTexthl": "LCInfoHighlight",
    \          "virtualTexthl": "LCInfoHighlight",
    \      },
    \      4: {
    \          "name": "Hint",
    \          "texthl": "",
    \          "signText": "»",
    \          "signTexthl": "LCHintHighlight",
    \          "virtualTexthl": "LCHinthighlight",
    \      }
    \  }
