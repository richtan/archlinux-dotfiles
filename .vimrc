""" richtan's vimrc
let s:vimfiles_dir = $HOME . (has('win32') || has('win32unix') || has('wsl')
      \ ? '/vimfiles/' : '/.vim/')
let &runtimepath = s:vimfiles_dir . ',' . &runtimepath

let g:mapleader = ','

if empty(getcwd())
  silent! execute 'cd ' . $HOME
endif

if has('gui_running')
  set guifont^=FuraMono\ Nerd\ Font\ 12
  set guioptions=cM
endif

augroup vimrc
  autocmd!
augroup END

function! s:curl_install(dest, url) abort
  if empty(glob(a:dest))
    echom 'Installing ' . fnamemodify(a:dest, ':t')
    call mkdir(fnamemodify(a:dest, ':h'), 'p')
    if executable('powershell')
      execute '!powershell Invoke-WebRequest -Uri ' . a:url .
            \ ' -OutFile ' . a:dest . ' -UseBasicParsing'
    else
      execute '!curl -fLo ' . a:dest . ' --create-dirs ' . a:url
    endif
  endif
endfunction

let s:external_deps = {'git': 'git', 'nodejs': 'node'}

function! s:check_deps() abort
  let l:missing_deps = []
  for dep in keys(s:external_deps)
    if !executable(s:external_deps[dep])
      call add(l:missing_deps, dep)
    endif
  endfor

  if len(l:missing_deps) > 0
    if executable('powershell')
      if executable('scoop')
        let s:scoop_cmd = 'Set-ExecutionPolicy -ExecutionPolicy RemoteSigned' .
              \ ' -Scope CurrentUser -Force; iwr -useb get.scoop.sh | iex; '
      else
        let s:scoop_cmd = ''
      endif
      let s:scoop_cmd += 'scoop install ' . join(l:missing_deps)
      let @+ = s:scoop_cmd
      echom 'Run this command in PowerShell to install missing dependencies (copied): ' .
            \ s:scoop_cmd
    else
      let @+ = join(l:missing_deps)
      echom 'Install missing dependencies and add them to $PATH (copied): ' . join(l:missing_deps)
    endif
  endif
endfunction

autocmd vimrc VimEnter * call <SID>check_deps()

""" Plugins
call <SID>curl_install(s:vimfiles_dir . 'autoload/plug.vim',
      \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')

runtime! macros/matchit.vim

if executable('git')
  nnoremap <leader>p :PlugClean<CR>:q<CR>:PlugUpdate<CR>

  autocmd vimrc VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) |
        \ PlugInstall --sync | q | source $MYVIMRC | endif

  call plug#begin(s:vimfiles_dir . 'plugged')

  Plug 'lifepillar/vim-gruvbox8'
  let g:gruvbox_filetype_hi_groups = 1
  let g:gruvbox_plugin_hi_groups = 1
  Plug 'sheerun/vim-polyglot'
  Plug 'tommcdo/vim-exchange'
  Plug 'tpope/vim-surround'
  Plug 'markonm/traces.vim'
  Plug 'tommcdo/vim-lion'
  let g:lion_squeeze_spaces = 1
  Plug 'vim-scripts/LargeFile'
  Plug 'machakann/vim-highlightedyank'
  Plug 'tpope/vim-commentary'
  Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
  nnoremap <leader>u :UndotreeToggle<cr>
  Plug 'honza/vim-snippets'
  Plug 'psliwka/vim-smoothie'
  Plug 'romainl/vim-cool'
  Plug 'airblade/vim-rooter'
  let g:rooter_patterns = [
        \'.git',
        \'.git/',
        \ '.python-version',
        \ 'LICENSE',
        \ 'manage.py',
        \ 'gradlew',
        \ ]
  let g:rooter_silent_chdir = 1
  let g:rooter_use_lcd = 1

  if executable('node')
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    let g:coc_global_extensions = [
          \ 'coc-css',
          \ 'coc-emmet',
          \ 'coc-html',
          \ 'coc-java',
          \ 'coc-json',
          \ 'coc-python',
          \ 'coc-snippets',
          \ 'coc-tsserver',
          \ 'coc-highlight',
          \ 'coc-pairs',
          \ 'coc-vimlsp',
          \ ]
    let g:coc_user_config = {
          \ 'diagnostic.checkCurrentLine': 'true',
          \ 'emmet.includeLanguages': {'htmldjango': 'html'},
          \ 'diagnostic.warningSign': '--',
          \ 'diagnostic.infoSign': '**',
          \ 'diagnostic.hintSign': '__',
          \ 'java.errors.incompleteClasspath.severity': 'ignore',
          \ 'suggest.enablePreview': 'true',
          \ 'languageserver': {
          \   'ccls': {
          \     'command': 'ccls',
          \     'filetypes': ['c', 'cpp', 'objc', 'objcpp'],
          \     'rootPatterns': ['.ccls', 'compile_commands.json', '.vim/', '.git/', '.hg/'],
          \     'initializationOptions': {
          \        'cache': {
          \          'directory': '/tmp/ccls',
          \          'retainInMemory': 1
          \        }
          \      }
          \   }
          \ }
          \ }

    let g:coc_snippet_prev = '<s-tab>'
    let g:coc_snippet_next = '<tab>'

    inoremap <silent><expr> <c-space> coc#refresh()
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gR <Plug>(coc-references)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-rename)

    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    xmap <leader>a <Plug>(coc-format-selected)
    nmap <leader>a <Plug>(coc-format)

    nnoremap <leader>i :CocCommand editor.action.organizeImport<cr>

    autocmd vimrc CursorHold * silent call CocActionAsync('highlight')

    function! s:show_documentation() abort
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction
    nnoremap <silent> K :call <SID>show_documentation()<CR>
  endif

  call plug#end()
endif

""" Options
filetype plugin indent on
syntax enable

set autoindent
set autoread
set backspace=indent,eol,start
set belloff=all
set breakindent
set clipboard^=unnamed,unnamedplus
set completeopt=menu,noinsert,menuone,noselect,preview
set copyindent
set display+=lastline
set encoding=utf-8
set expandtab
set foldenable
set foldlevelstart=99
set foldmethod=marker
set gdefault
set hidden
set history=10000
set hlsearch
set ignorecase
set incsearch
set infercase
set laststatus=2
set lazyredraw
set list
set listchars=tab:<->,extends:>,precedes:<,nbsp:·,trail:·
set mouse=a
set mousemodel=extend
set nobackup
set nojoinspaces
set ruler
set noshowcmd
set showmode
set noswapfile
set nrformats=bin,hex,alpha
set path+=**
set report=0
set scrolloff=5
set sessionoptions-=options
set shiftround
set shiftwidth=2
set shortmess+=caF
set shortmess-=S
set showfulltag
set showtabline=0
set sidescroll=1
set sidescrolloff=7
set signcolumn=yes
set smartcase
set smartindent
set smarttab
set softtabstop=2
set splitbelow
set splitright
set switchbuf=usetab
set synmaxcol=300
set tagcase=followscs
set termguicolors
set textwidth=100
set tildeop
set timeoutlen=500
set title
set ttimeoutlen=1
set undofile
set updatetime=100
set wildcharm=<c-z>
set wildignore+=*.pyc,*/__pycache__/,*.class
set wildignore+=*.swp,*.jpg,*.png,*.gif,*.pdf,*.bak,*.tar,*.zip,*.tgz
set wildignore+=*/.hg/*,*/.svn/*,*/.git/*
set wildignore+=*/vendor/cache/*,*/public/system/*,*/tmp/*,*/log/*,*/solr/data/*,*/.DS_Store
set wildignorecase
set wildmenu

scriptencoding utf-8

let &showbreak = '> '

let &undodir = s:vimfiles_dir . 'undo'

let g:netrw_banner = 0

if has('nvim')
  let g:loaded_python_provider = 0
  let g:loaded_python3_provider = 0
  let g:loaded_node_provider = 0
  let g:loaded_ruby_provider = 0
  augroup vimrc
    autocmd TermOpen,BufEnter term://* startinsert
    autocmd UIEnter * silent! GuiFont FuraMono Nerd Font:h12
    autocmd UIEnter * silent! GuiPopupmenu 0
    autocmd UIEnter * silent! GuiTabline 0
  augroup END
else
  set ttyfast
  set t_vb=
  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[2 q"
endif

""" Autocommands
augroup vimrc
  autocmd BufEnter * let &titlestring = hostname() . ":" . expand("%:p")
  autocmd BufEnter * set formatoptions-=cro
  autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") |
        \ exe "normal! g`\"" | endif
augroup END

""" Mappings
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
nnoremap ^ g^
nnoremap $ g$
nnoremap g^ ^
nnoremap g$ $
xnoremap j gj
xnoremap k gk
xnoremap gj j
xnoremap gk k
xnoremap ^ g^
xnoremap $ g$
xnoremap g^ ^
xnoremap g$ $

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

inoremap jk <esc>
inoremap kj <esc>

nnoremap U <C-r>

nnoremap ; :
xnoremap ; :

xnoremap < <gv
xnoremap > >gv

nnoremap Y y$

execute 'nnoremap <leader>v :e ' . expand('<sfile>') . '<cr>'

nnoremap ' `
nnoremap ` '

nnoremap <expr> n 'Nn'[v:searchforward]
xnoremap <expr> n 'Nn'[v:searchforward]
onoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]
xnoremap <expr> N 'nN'[v:searchforward]
onoremap <expr> N 'nN'[v:searchforward]

tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l
tnoremap <esc> <c-\><c-n>

vnoremap * y/\V<c-r>=escape(@",'/\')<cr><cr>

inoremap <c-j> <C-n>
inoremap <c-k> <C-p>
cnoremap <c-j> <C-n>
cnoremap <c-k> <C-p>

nnoremap <leader>f :e **/*
nnoremap <leader>c :colo 

nnoremap <expr> <leader>b &bg=='light' ? ":set bg=dark<cr>" : ":set bg=light<cr>"

""" Colors
silent! execute 'colorscheme gruvbox8_hard'
set background=dark
