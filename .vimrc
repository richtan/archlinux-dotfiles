""" richtan's vimrc
let s:vimdir = $HOME . (has('unix') ? '/.vim/' : '/vimfiles/') " Custom config location
let g:vimrc_path = expand('<sfile>') " Vimrc path
let g:mapleader = ','
let s:colors_name = 'palenight'

" Share Nvim and Vim config
let &runtimepath = s:vimdir . ',' . s:vimdir . 'after' . ',' . &runtimepath
let &packpath=&runtimepath

" Create and reset custom augroup
augroup vimrc
  autocmd!
augroup END

" Download file from the web
function! s:download_file(dest, url) abort
  if empty(glob(a:dest))
    echom 'Downloading ' . fnamemodify(a:dest, ':t') . ' to ' . fnamemodify(a:dest, ':h')
    call mkdir(fnamemodify(a:dest, ':h'), 'p')
    if executable('powershell')
      silent! execute '!powershell iwr -ur ' . a:url . ' -outf ' . a:dest . ' -useb'
    else
      silent! execute '!curl -fLo ' . a:dest . ' --create-dirs ' . a:url
    endif
  endif
endfunction

""" Plugins
runtime! macros/matchit.vim
runtime! ftplugin/man.vim

silent! call <SID>download_file(s:vimdir . 'autoload/xd.vim', 'https://raw.githubusercontent.com/richtan/vim-xd/master/autoload/xd.vim') " Install vim-xd
call xd#check_external_dependencies({'git': ['git', 'git'], 'node': ['node', 'nodejs'], 'ccls': ['ccls', ''], 'fzf': ['', 'fzf'], 'ctags': ['ctags', 'ctags'], 'fd': ['fd', 'fd'], 'bat': ['bat', 'bat'], 'rg': ['ripgrep', 'ripgrep'], 'ruby': ['ruby', 'ruby'], 'python': ['python', 'python']}, ['ruby', 'python3'])

silent! call <SID>download_file(s:vimdir . 'autoload/plug.vim', 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim') " Install vim-plug
nnoremap <leader>p :PlugClean<CR>:q<cr>:PlugUpgrade<CR>:PlugUpdate<CR>
autocmd vimrc VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)')) && executable('git') | PlugInstall --sync | q | source $MYVIMRC | call s:lightline_update() | endif

call plug#begin(s:vimdir . 'bundle')

Plug 'morhetz/gruvbox'
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_contrast_light = 'hard'
let g:gruvbox_sign_column = 'bg0'
Plug 'drewtempelmeyer/palenight.vim'
Plug 'romainl/apprentice'
Plug 'joshdick/onedark.vim'
Plug 'tomasr/molokai'
Plug 'sheerun/vim-polyglot'
Plug 'jaxbot/semantic-highlight.vim'
nnoremap <leader>sh :SemanticHighlightToggle<cr>

Plug 'mengelbrecht/lightline-bufferline'
let g:lightline#bufferline#show_number = 2
let g:lightline#bufferline#unnamed = '[No Name]'
nmap <Leader>1 <Plug>lightline#bufferline#go(1)
nmap <Leader>2 <Plug>lightline#bufferline#go(2)
nmap <Leader>3 <Plug>lightline#bufferline#go(3)
nmap <Leader>4 <Plug>lightline#bufferline#go(4)
nmap <Leader>5 <Plug>lightline#bufferline#go(5)
nmap <Leader>6 <Plug>lightline#bufferline#go(6)
nmap <Leader>7 <Plug>lightline#bufferline#go(7)
nmap <Leader>8 <Plug>lightline#bufferline#go(8)
nmap <Leader>9 <Plug>lightline#bufferline#go(9)
nmap <Leader>0 <Plug>lightline#bufferline#go(10)
Plug 'itchyny/lightline.vim'
let g:lightline = {}
let g:lightline.colorscheme = s:colors_name
let g:lightline.active = {
      \ 'left': [
      \   ['mode', 'paste'],
      \   ['gitbranch', 'readonly', 'absolutepath', 'modified'],
      \ ],
      \ 'right': [
      \   [],
      \   ['percent', 'lineinfo', 'filetype'],
      \ ],
      \ }
let g:lightline.inactive = {
      \ 'left': [['absolutepath']],
      \ 'right': [
      \   ['lineinfo'],
      \   ['percent'],
      \ ],
      \ }
let g:lightline.tabline = {
      \ 'left': [['buffers']],
      \ 'right': [['bufferline_label']],
      \ }
let g:lightline.component_expand = {
      \ 'buffers': 'lightline#bufferline#buffers',
      \ }
let g:lightline.component_function = {
      \ 'gitbranch': 'fugitive#head',
      \ }
let g:lightline.component = {
      \ 'bufferline_label': 'Buffers',
      \ }
let g:lightline.component_type = {
      \ 'buffers': 'tabsel',
      \ }
function! s:lightline_update()
  if !exists('g:loaded_lightline')
    return
  endif
  silent! let g:lightline.colorscheme = g:colors_name
  silent! execute 'runtime! autoload/lightline/colorscheme/*' . g:colors_name . '*.vim'
  silent! call lightline#init()
  silent! call lightline#colorscheme()
  silent! call lightline#update()
endfunction
autocmd vimrc ColorScheme * call s:lightline_update()
autocmd vimrc OptionSet * if expand('<amatch>') == 'background' | call s:lightline_update() | endif

Plug 'coderifous/textobj-word-column.vim'
Plug 'romainl/vim-qf'
nmap [q <Plug>(qf_qf_previous)
nmap ]q <Plug>(qf_qf_next)
Plug 'tpope/vim-dadbod', {'on': 'DB'}
Plug 'tpope/vim-speeddating'
Plug 'rhysd/vim-grammarous', {'on': 'GrammarousCheck'}
Plug 'reedes/vim-wordy', {'on': 'Wordy'}
Plug 'sodapopcan/vim-twiggy', {'on': 'Twiggy'}
Plug 'rbong/vim-flog', {'on': 'Flog'}
Plug 'roxma/vim-paste-easy'
Plug 'wellle/tmux-complete.vim'
Plug 'dohsimpson/vim-macroeditor', {'on': 'MacroEdit'}
silent! execute 'nnoremap <leader>m :MacroEdit '
Plug 'weilbith/nerdtree_choosewin-plugin'
Plug 't9md/vim-choosewin'
nmap - <Plug>(choosewin)
let g:choosewin_overlay_enable = 1

Plug 'majutsushi/tagbar', {'on': 'TagbarToggle'}
nnoremap <leader>T :TagbarToggle<cr>

Plug 'matze/vim-move'
let g:move_key_modifier = 'C'

Plug 'alvan/vim-closetag'
Plug 'tpope/vim-repeat'
Plug 'glts/vim-radical'
Plug 'glts/vim-magnum'
Plug 'roman/golden-ratio'
let g:golden_ratio_wrap_ignored = 1
let g:golden_ratio_exclude_nonmodifiable = 1
nnoremap <leader>gr :GoldenRatioToggle<cr>

Plug 'wellle/targets.vim'
Plug 'terryma/vim-expand-region'
Plug 'dhruvasagar/vim-table-mode'
Plug 'kshenoy/vim-signature'
nnoremap <leader>st :SignatureToggle<cr>

Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-eunuch'
Plug 'ntpeters/vim-better-whitespace'
let g:better_whitespace_enabled = 1
let g:better_whitespace_operator = ''

Plug 'luochen1990/rainbow', {'on': 'RainbowToggle'}
let g:rainbow_active = 0
nnoremap <leader>r :RainbowToggle<cr>

if executable('fzf') || !has('win32')
  Plug 'junegunn/fzf', has('win32') ? {} : {'dir': '~/.fzf', 'do': './install --all'}
  Plug 'junegunn/fzf.vim'
  if executable('fd')
    let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
  endif
  let g:fzf_layout = {
        \ 'window': 'new | wincmd J | resize 1 | call animate#window_percent_height(0.25)'
        \ }
  if executable('bash') && (executable('cat') || executable('bat'))
    command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
  endif
  nnoremap <leader>ff :Files<CR>
  nnoremap <leader>fF :Files $HOME<CR>
  nnoremap <leader>fl :Lines<CR>
  nnoremap <leader>fg :GFiles<CR>
  nnoremap <leader>fL :BLines<CR>
  nnoremap <leader>fb :Buffers<cr>
  nnoremap <leader>fT :Tags<cr>
  nnoremap <leader>ft :BTags<cr>
  nnoremap <leader>fh :History<cr>
  nnoremap <leader>fH :Helptags<cr>
  nnoremap <leader>fm :Maps<cr>
  nnoremap <leader>fc :Colors<cr>
  nnoremap <leader>fC :Commits<cr>
  if executable('rg')
    nnoremap <leader>fr :Rg<CR>
  endif
  autocmd vimrc FileType fzf silent! tunmap <esc>
endif

Plug 'dstein64/vim-startuptime', {'on': 'StartupTime'}
let g:startuptime_split_edit_key_seq = 'gf'

if has('win32') && executable('py')
  Plug 'Yggdroot/LeaderF', {'do': '.\install.bat'}
elseif executable('python')
  Plug 'Yggdroot/LeaderF', {'do': './install.sh'}
endif

Plug 'machakann/vim-sandwich'
autocmd vimrc VimEnter * runtime macros/sandwich/keymap/surround.vim
Plug 'andrewradev/splitjoin.vim'

Plug 'markonm/traces.vim'
Plug 'junegunn/vim-easy-align', {'on': '<Plug>(EasyAlign)'}
map ga <Plug>(EasyAlign)

Plug 'chrisbra/colorizer', {'on': 'ColorToggle'}
let g:colorizer_x11_names = 1
nnoremap <leader>ct :ColorToggle<cr>

Plug 'junegunn/goyo.vim', {'on': 'Goyo'}
nnoremap <leader>d :Goyo<cr>
autocmd! vimrc User GoyoEnter Limelight
autocmd! vimrc User GoyoLeave Limelight!
Plug 'junegunn/limelight.vim', {'on': ['Limelight', 'Limelight!']}
let g:limelight_priority = -1

Plug 'easymotion/vim-easymotion', {'on': ['<Plug>(easymotion-overwin-f)', '<Plug>(easymotion-overwin-f2)']}
let g:EasyMotion_smartcase = 1
nmap f <Plug>(easymotion-overwin-f)
nmap F <Plug>(easymotion-overwin-f2)

Plug 'tpope/vim-endwise'
Plug 'pbrisbin/vim-mkdir'
Plug 'farmergreg/vim-lastplace'

Plug 'Yggdroot/indentLine'
let g:indentLine_char_list = ['▏']
let g:indentLine_fileTypeExclude = ['help', 'startify']

Plug 'vim-scripts/LargeFile'
Plug 'machakann/vim-highlightedyank'
Plug 'mhinz/vim-startify'
let g:startify_session_dir = s:vimdir . 'session'
let g:startify_bookmarks = [{'v': g:vimrc_path}]
nnoremap <leader>S :Startify<cr>
nnoremap <leader>sl :SLoad<cr>
nnoremap <leader>ss :SSave!<cr>
nnoremap <leader>sd :SDelete<cr>
nnoremap <leader>sc :SClose<cr>

Plug 'tomtom/tcomment_vim'
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'}
nnoremap <leader>U :UndotreeToggle<cr>

Plug 'tmsvg/pear-tree'
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1
Plug 'honza/vim-snippets'
Plug 'psliwka/vim-smoothie'
Plug 'romainl/vim-cool'
Plug 'chrisbra/unicode.vim'
nnoremap <leader>un :UnicodeName<cr>
Plug 'wincent/terminus'
Plug 'vim-scripts/AdvancedSorters'
Plug 'airblade/vim-rooter'
let g:rooter_patterns = [
      \ 'LICENSE',
      \ 'src/',
      \ 'manage.py',
      \ 'gradlew',
      \ '.python-version',
      \'.git',
      \'.git/',
      \ ]
let g:rooter_silent_chdir = 1
let g:rooter_use_lcd = 1

Plug 'tpope/vim-sleuth'
if executable('ctags')
  Plug 'ludovicchabant/vim-gutentags'
  let g:gutentags_project_root = g:rooter_patterns
endif

Plug 'tpope/vim-vinegar'
let g:netrw_dirhistmax = 0

Plug 'tpope/vim-fugitive'
nnoremap <leader>gg :G<cr>
nnoremap <leader>gB :Gblame<cr>
nnoremap <leader>gl :Glog<cr>
nnoremap <leader>gc :Gcommit<cr>
nnoremap <leader>gp :Gpush<cr>
nnoremap <leader>gb :Gbrowse<cr>
Plug 'rhysd/committia.vim'
Plug 'tpope/vim-rhubarb'

Plug 'sbdchd/neoformat', {'on': 'Neoformat'}
let g:neoformat_basic_format_align = 1
let g:neoformat_basic_format_retab = 1
let g:neoformat_basic_format_trim = 1
nnoremap <leader>a :Neoformat <c-r>=&filetype<cr><cr>
xnoremap <leader>a :Neoformat! <c-r>=&filetype<cr><cr>

Plug 'andrewradev/sideways.vim', {'on': ['SidewaysLeft', 'SidewaysRight']}
nnoremap <leader>H :SidewaysLeft<cr>
nnoremap <leader>L :SidewaysRight<cr>

Plug 'vim-scripts/ZoomWin'
Plug 'wesq3/vim-windowswap'
let g:windowswap_map_keys = 0
nnoremap <silent> <leader>W :call WindowSwap#EasyWindowSwap()<CR>

Plug 'junegunn/vim-github-dashboard', {'on': ['GHActivity', 'GHDashboard']}
let s:github_username = 'richtan'
let g:github_dashboard = {'username': s:github_username}
nnoremap <leader>Ga :GHActivity<cr>
nnoremap <leader>Gd :GHDashboard<cr>
Plug 'lambdalisue/vim-gista', {'on': 'Gista'}
let g:gista#client#default_username = s:github_username

Plug 'lambdalisue/suda.vim'
let g:suda#prefix = ['suda://', 'sudo://', '_://']
let g:suda_smart_edit = 1
Plug 'tpope/vim-capslock'
Plug 'itchyny/calendar.vim', {'on': 'Calendar'}
nnoremap <leader>C :Calendar<cr>
Plug 'sotte/presenting.vim', {'on': 'PresentingStart'}
nnoremap <leader>ps :PresentingStart<cr>
Plug 'mhinz/vim-signify'
let g:signify_skip = {'vcs': { 'allow': ['git']}}

Plug 'chrisbra/nrrwrgn'
let g:nrrw_rgn_nomap_nr = 1
let g:nrrw_rgn_nomap_Nr = 1

Plug 'vimwiki/vimwiki'
Plug 'moll/vim-bbye', {'on': ['Bdelete', 'Bwipeout']}
nnoremap <leader>Bw :Bwipeout<cr>
nnoremap <leader>Bd :Bdelete<cr>
Plug 'idanarye/vim-merginal', {'on': 'Merginal'}
Plug 'Shougo/vimproc.vim'

Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'vim-nerdtree/nerdtree'
nnoremap <expr><silent> <leader>n g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeQuitOnOpen = 1
autocmd StdinReadPre * let s:std_in=1
" Quit Vim if only NERDTree open
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

Plug 'camspiers/animate.vim'
let g:animate#duration = 180.0

if executable('node')
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  let g:coc_global_extensions = ['coc-css', 'coc-emmet', 'coc-html', 'coc-java', 'coc-json', 'coc-python', 'coc-emoji', 'coc-snippets', 'coc-tsserver', 'coc-vimlsp', 'coc-calc']
  let g:coc_user_config = {
        \ 'diagnostic.checkCurrentLine': 'true',
        \ 'emmet.includeLanguages': {'htmldjango': 'html'},
        \ 'diagnostic.warningSign': '--',
        \ 'diagnostic.infoSign': '**',
        \ 'diagnostic.hintSign': '__',
        \ 'coc.source.emoji.filetypes': ['text', 'markdown'],
        \ 'java.errors.incompleteClasspath.severity': 'ignore',
        \ 'suggest.enablePreview': 'true',
        \ 'languageserver': {}
        \ }
  if executable('ccls')
    let g:coc_user_config['languageserver']['ccls'] = {
          \   'command': 'ccls',
          \   'filetypes': ['c', 'cpp', 'objc', 'objcpp'],
          \   'rootPatterns': ['.ccls', 'compile_commands.json', '.vim/', '.git/', '.hg/'],
          \   'initializationOptions': {
          \      'cache': {
          \        'directory': '/tmp/ccls',
          \      }
          \    }
          \ }
  endif

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

  nmap <Leader>ca <Plug>(coc-calc-result-append)
  nmap <Leader>cr <Plug>(coc-calc-result-replace)

  nnoremap <leader>i :CocCommand editor.action.organizeImport<cr>

  function! s:show_documentation() abort
    if (index(['vim','help'], &filetype) >= 0)
      silent! execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! FindCursorPopUp() abort
    let radius = get(a:000, 0, 2)
    let srow = screenrow()
    let scol = screencol()
    for r in range(srow - radius, srow + radius)
      for c in range(scol - radius, scol + radius)
        let winid = popup_locate(r, c)
        if winid != 0
          return winid
        endif
      endfor
    endfor
    return 0
  endfunction

  function! ScrollPopUp(down) abort
    let winid = FindCursorPopUp()
    if winid == 0
      return 0
    endif
    let pp = popup_getpos(winid)
    call popup_setoptions( winid,
          \ {'firstline' : pp.firstline + ( a:down ? 1 : -1 ) } )
    return 1
  endfunction
  nnoremap <expr> <down> ScrollPopUp(1) ? '<esc>' : '<down>'
  nnoremap <expr> <up> ScrollPopUp(0) ? '<esc>' : '<up>'

  " Lightline module for coc.nvim
  call add(g:lightline.active.right[0], 'cocstatus')
  let g:lightline.component_function.cocstatus = 'coc#status'
endif

Plug 'ryanoasis/vim-devicons'

call plug#end()

""" Options
filetype plugin indent on
syntax enable

set autoindent
set autoread
set backspace=indent,eol,start
set guifont^=FuraMono\ Nerd\ Font\ 12
set guioptions=cM
set confirm
set belloff=all
set breakindent
set clipboard=unnamed,unnamedplus
set completeopt=menu,noinsert,menuone,noselect
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
set nolist
set mouse=a
set mousemodel=extend
set nobackup
set number
set nojoinspaces
set ruler
set showcmd
set noshowmode
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
set showtabline=2
set sidescroll=1
set sidescrolloff=7
set signcolumn=yes
set smartcase
set nocursorline
set smartindent
set smarttab
set softtabstop=2
set splitbelow
set splitright
set switchbuf=usetab
set synmaxcol=300
set tagcase=followscs
set termguicolors
set notildeop
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
set ttyfast
set t_vb=

scriptencoding utf-8

let &undodir = s:vimdir . 'undo'
let &showbreak = '> '

if has('nvim')
  let g:loaded_python_provider = 0
  let g:loaded_node_provider = 0
  augroup vimrc
    autocmd TermOpen,BufEnter term://* startinsert
    autocmd UIEnter * silent! GuiFont! FuraMono Nerd Font:h12
    autocmd UIEnter * silent! GuiPopupmenu 0
    autocmd UIEnter * silent! GuiTabline 0
  augroup END
endif

""" Autocommands
augroup vimrc
  " Don't copy comment leader when adding newline
  autocmd BufEnter * set formatoptions-=cro

  " Auto-close completion popup window
  autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END

""" Commands
" Change GUI font
command! Bigger :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)+1', '')
command! Smaller :let &guifont = substitute(&guifont, '\d\+$', '\=submatch(0)-1', '')

""" Mappings

" Move by visual lines
noremap j gj
noremap k gk
noremap gj j
noremap gk k
noremap ^ g^
noremap $ g$
noremap g^ ^
noremap g$ $

" Easier undo
nnoremap U <C-r>

" Easier colon
nnoremap ; :
xnoremap ; :

" Keep selection after indenting
xnoremap < <gv
xnoremap > >gv

" Make yank work like delete
nnoremap Y y$

" Open vimrc
nnoremap <leader>v :e <c-r>=g:vimrc_path<cr><cr>
nnoremap <leader>V :e $MYVIMRC<cr>

" Toggle mark navigation leaders
nnoremap ' `
nnoremap ` '

" 'n' always searches forward
noremap <expr> n 'Nn'[v:searchforward]
noremap <expr> N 'nN'[v:searchforward]

" Make ESC work in terminal mode
tnoremap <esc> <c-\><c-n>

" Search for selection like word
vnoremap * y/\V<c-r>=escape(@",'/\')<cr><cr>

" Completion menu scroll
inoremap <c-j> <C-n>
inoremap <c-k> <C-p>
cnoremap <c-j> <C-n>
cnoremap <c-k> <C-p>

" Digraph input
inoremap <c-d> <c-k>

" Toggle background type
nnoremap <expr> <leader>b &bg=='light' ? ":set bg=dark<cr>" : ":set bg=light<cr>"

""" Colors
silent! execute 'colorscheme ' . s:colors_name
set background=dark
