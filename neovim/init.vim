scriptencoding utf-8
set encoding=utf-8
set nocompatible                " choose no compatibility with legacy vi
filetype off

set runtimepath+=~/.vim,~/.vim/after
set packpath+=~/.vim

call plug#begin('~/.nvvim/plugged')

" Languages
" Plug 'pangloss/vim-javascript'
" Plug 'HerringtonDarkholme/yats.vim'

" Plug 'hail2u/vim-css3-syntax'
" Plug 'vim-python/python-syntax'
" Plug 'vim-scripts/indentpython.vim'
" Plug 'tweekmonster/django-plus.vim'
" Plug 'mitsuhiko/vim-jinja'

" Plug 'groenewege/vim-less'
" Plug 'juvenn/mustache.vim'

" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'folke/trouble.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" Plug 'dense-analysis/ale'
Plug 'mileszs/ack.vim'
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'Lokaltog/vim-easymotion'
Plug 'tpope/vim-fugitive'
Plug 'tomtom/tcomment_vim'
Plug 'jiangmiao/auto-pairs'
Plug 'ludovicchabant/vim-gutentags'
" Plug 'neovim/nvim-lspconfig'

" Colors
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'morhetz/gruvbox'
Plug 'sainnhe/everforest'
Plug 'w0ng/vim-hybrid'
Plug 'joshdick/onedark.vim'
Plug 'arcticicestudio/nord-vim'

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
" colorscheme nord

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

" last visual
noremap <leader>v `[V`]

" Move windows
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>c :ccl \| pc \| TroubleClose<CR>

nnoremap <Leader>j :call IssueKey()<CR>
function! IssueKey()
  let key = system("git symbolic-ref HEAD | awk 'match($0, /[A-Z]+-[0-9]+/) { printf \"%s\",substr($0, RSTART, RLENGTH) }'")
  call setline(line('.'), getline('.').'['.key.'] ')
endfunction

" if (has("termguicolors"))
"   set termguicolors
" endif

" " Colors
" White
hi tsxConstructor ctermfg=7

" Blue
hi typescriptVariable ctermfg=110
hi typescriptExport ctermfg=110
hi typescriptImport ctermfg=110
hi tsxTagDelimiter ctermfg=110
hi TSKeyword ctermfg=110

" Purple
hi typescriptAliasDeclaration ctermfg=139
hi typescriptTypeReference ctermfg=139
hi typescriptTypeParameter ctermfg=139
hi typescriptPredefinedType ctermfg=139
hi TSKeywordReturn ctermfg=139
hi TSVariableBuiltin ctermfg=139

" Red
hi tsxTagAttribute ctermfg=167

" Yellow
hi typescriptArrowFuncArg ctermfg=yellow

" Background
hi Conceal guibg=#303030 ctermbg=235

" Hilight test
" :so $VIMRUNTIME/syntax/hitest.vim

" tsx
" hi TSTagDelimiter = open/close brackets

" Easymotion
let g:EasyMotion_smartcase = 1
" map \ <Plug>(easymotion-sn)
" map \ <Plug>(easymotion-sn)

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
" nmap <leader>f :GFiles<CR>
" nmap <leader>t :Tags<CR>
" nmap <leader>T :BTags<CR>
" nmap ; :Buffers<CR>
" nmap <leader>l :Lines<CR>
" " nmap <space> :BLines<CR>
" nmap <space> :BLines<CR>
" nmap <leader>b :Lines<CR>
" nmap <leader>h :History<CR>
" set grepprg=rg\ --vimgrep\ --no-heading
" set grepformat=%f:%l:%c:%m,%f:%l:%m
" set grepprg=rg\ --vimgrep
command! -nargs=+ -bar Find silent! grep! <args>|cwindow

" Telescope
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>t <cmd>Telescope tags<cr>
nnoremap ; <cmd>Telescope buffers<cr>
nnoremap \ <cmd>Telescope live_grep<cr>
nnoremap <leader>T <cmd>Telescope current_buffer_tags<cr>
nmap <space> <cmd>Telescope current_buffer_fuzzy_find<cr>

" Trouble
nnoremap <leader>x <cmd>TroubleToggle<cr>


" Linting / ESLint
" autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll

" " ALE
let g:ale_linters = {}
"
" let g:ale_linters.javascript = ['eslint']
" let g:ale_linters.javascriptreact = ['eslint']
" let g:ale_linters.typescript = ['eslint', 'tsserver']
" let g:ale_linters.typescriptreact = ['eslint', 'tsserver']
" let g:ale_linters.python = ['pyright']
let g:ale_linters.python = []
let g:ale_linters.javascript = []
let g:ale_linters.typescript = []
let g:ale_linters.typescriptreact = []
" let g:ale_python_pyright_config = {
" \  'python': {
" \    'analysis': {
" \      'extraPaths': ['/Users/mfrauenholtz/Code']
" \    },
" \  },
" \}

"
let g:ale_fixers = {}
let g:ale_fixers.javascript = ['prettier']
let g:ale_fixers.typescript = ['prettier']
let g:ale_fixers.typescriptreact = ['prettier']
let g:ale_fix_on_save = 1
"
" nmap <leader>g <Plug>(ale_go_to_definition)
nmap <leader>k <Plug>(ale_hover)

" " Use ALE's function for omnicompletion.
" set omnifunc=ale#completion#OmniFunc
" let g:ale_completion_enabled = 1
" " Hide preview while completing
" set completeopt-=preview

let g:python_host_prog = '/usr/local/opt/python@3.9/libexec/bin/python'
let g:python3_host_prog = '/usr/local/opt/python@3.9/libexec/bin/python'
let g:python_highlight_all = 1


" ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' '
" coc keybinds
" ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' '

" autocmd FileType python let b:coc_root_patterns = ['.git', 'venv', 'bitbucket']
"
" " GoTo code navigation.
" nmap <silent> <leader>g <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)
"
" " Use K to show documentation in preview window.
" nnoremap <silent> K :call <SID>show_documentation()<CR>
"
" function! s:show_documentation()
"   if CocAction('hasProvider', 'hover')
"     call CocActionAsync('doHover')
"   else
"     call feedkeys('K', 'in')
"   endif
" endfunction



lua <<EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = { "python", "json", "javascript", "query", "html" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  -- sync_install = false,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = {},

  intent = {
    enable = true,
  },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "rust" },

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
require"nvim-treesitter.highlight".set_custom_captures {
  ["tag"] = "tsxTag",
  ["constructor"] = "tsxConstructor",
  ["tag.delimiter"] = "tsxTagDelimiter",
  ["tag.attribute"] = "tsxTagAttribute",
}

-- ====================
-- nvim-lspconfig
-- ====================

local null_ls = require("null-ls")
local sources = {
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.diagnostics.eslint_d,
}
null_ls.setup({
  sources = sources,
  on_attach = function(client)
    if client.resolved_capabilities.document_formatting then
      vim.cmd([[
        augroup LspFormatting
          autocmd! * <buffer>
          autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
        augroup END
      ]])
    end
  end,
})

-- ====================
-- nvim-telescope
-- ====================

require('telescope').setup {
  mode = "document_diagnostics",
  -- extensions = { fzf = {} }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
-- require('telescope').load_extension('fzf')

-- ====================
-- nvim-trouble
-- ====================

require("trouble").setup {
  icons = false,
  mode = "document_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
  auto_open = false, -- automatically open the list when you have diagnostics
  auto_close = true, -- automatically close the list when you have no diagnostics
  auto_preview = false, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
}

-- ====================
-- nvim-lspconfig
-- ====================

local opts = { noremap=true, silent=true }
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>g', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end


-- Setup nvim-cmp.
local cmp = require'cmp'
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--   sources = cmp.config.sources({
--     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--   }, {
--     { name = 'buffer' },
--   })
-- })
-- 
-- -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline('/', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = {
--     { name = 'buffer' }
--   }
-- })

-- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
-- cmp.setup.cmdline(':', {
--   mapping = cmp.mapping.preset.cmdline(),
--   sources = cmp.config.sources({
--     { name = 'path' }
--   }, {
--     { name = 'cmdline' }
--   })
-- })


-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require'lspconfig'.pyright.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        extraPaths = {"/Users/mfrauenholtz/Code"}
      },
    },
  },
}
require'lspconfig'.tsserver.setup {
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
    on_attach(client, bufnr)
  end,
}

EOF
