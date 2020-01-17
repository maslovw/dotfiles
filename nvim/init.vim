" set ff=dos

call plug#begin('~/dotfiles/nvim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'rakr/vim-one'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-fugitive'

Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

Plug 'flxo/bake.vim'
Plug 'drmikehenry/vim-headerguard'

Plug 'altercation/vim-colors-solarized'
Plug 'tpope/vim-dispatch'
call plug#end()

source $MYVIMRC/../esr.vim
source $MYVIMRC/../bake.vim
" Key maps
" remap jk to ESC
inoremap jk <ESC>
" paste from global buf
nnoremap <S-Insert> "+p
" copy from global buf
vnoremap <C-Insert> "+y
" Smart way to move between windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
" resize splits
nnoremap <M-Up> <C-W>+
nnoremap <M-Down> <C-W>-
nnoremap <M-Left> <C-W><
nnoremap <M-Right> <C-W>>

nnoremap <C-F12> :NERDTreeFind<CR>
nnoremap <C-Tab> :tabNext<CR>

" save
nmap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR><ESC>

inoremap <C-Space> <C-x><C-n>

" remove hightlight on next enter after search
nnoremap <silent> <CR> :noh<CR><CR>

cnoremap <C-N> <UP>
cnoremap <C-P> <Down>


set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:·
set list

set nocompatible
" configs
set wildmenu
set relativenumber
set number
set colorcolumn=120
set ignorecase
set hlsearch
set incsearch
highlight ColorColumn ctermbg=0 guibg=lightgrey
set tabstop=4 shiftwidth=4 expandtab
set hidden
set nowrap


" temporary files
if has("win32")
    set backupdir=c:\\temp\\vim\\backup\\
    set directory=c:\\temp\\vim\\swp\\
    set undodir=c:\\temp\\vim\\undo\\
else
    set backupdir=.backup/,~/.backup/,/tmp//
    set directory=.swp/,~/.swp/,/tmp//
    set undodir=.undo/,~/.undo/,/tmp//
endif



syntax enable
filetype plugin on

"
" colorscheme
" True color support
if (empty($TMUX))
  if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
     set termguicolors
  endif
endif


" let g:python3_host_prog='C:\Apps\python\python37\python.exe'
let g:airline_theme='one'
colorscheme one
set background=dark
set cursorline

set title

augroup dirchange
    autocmd!
    autocmd DirChanged * let &titlestring=v:event['cwd']
augroup END

" CtrlP config
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_working_path_mode = 'rwa'
let g:ctrlp_by_filename = 0

set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.stackdump,*.o,*.pyc " Windows
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|rim|bake)$',
  \ 'file': '\v\.(exe|so|dll|a|stackdump|cmdline|d|o|bake)$',
  \ }


" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee,*.cpp,*.h :call CleanExtraSpaces()
endif

let g:bake_custom_args = "--time -r"


" Open PDF as text using `pdftotxt` tool
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> -
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -csw78
