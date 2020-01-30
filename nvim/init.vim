" set ff=dos
"disable netrw
"let g:loaded_netrw       = 1
"let g:loaded_netrwPlugin = 1

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
Plug 'iamcco/markdown-preview.nvim'
call plug#end()

let s:vimrc_path = expand('<sfile>:p:h')

exec "source " . s:vimrc_path . "/esr.vim"
exec "source " . s:vimrc_path . "/bake.vim"


let mapleader = ","
" Key maps
" remap jk to ESC
inoremap jk <ESC>
" paste from global buf
nnoremap <S-Insert> "+p
" copy from global buf
vnoremap <C-Insert> "+y

" copy relative path
nnoremap yp :let @" = expand("%")<CR>
" copy full path
nnoremap yP :let @" = expand("%:p")<CR>
" copy file name
nnoremap yf :let @" = expand("%:t")<CR>

" Smart way to move between windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" Move window to most *left, right...
nnoremap <Leader>j <C-W>J
nnoremap <Leader>k <C-W>K
nnoremap <Leader>h <C-W>H
nnoremap <Leader>l <C-W>L

" jump to top window
nnoremap <Leader>K <C-W>t
nnoremap <Leader>J <C-W>b
nnoremap <Leader>H 10<C-W>h<C-W>t
nnoremap <Leader>L 10<C-W>l

"go to previously accessed window 
nnoremap <M-Left> <C-W>p
nnoremap <M-Right> <C-W>n

" resize splits
nnoremap <M-Up> <C-W>+
nnoremap <M-Down> <C-W>-
nnoremap <M-Left> <C-W><
nnoremap <M-Right> <C-W>>

nnoremap <silent> <F12> :NERDTree<CR>
nnoremap <silent> <C-F12> :NERDTreeFind<CR>
nnoremap <silent> <C-Tab> :tabNext<CR>
nnoremap <silent> <C-T> :tabnew<CR>

" Git 
nnoremap <silent> <Leader>fF :Ggrep! <cword> ** <bar> :copen <CR>

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

" automatically scroll at the end/beginning of the screen
set scrolloff=3


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

set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.stackdump,*.o,*.pyc " Windows
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" CtrlP config
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_working_path_mode = 'rwa'
let g:ctrlp_by_filename = 0


" let g:ctrlp_mruf_exclude = {
"   \ 'dir':  '\v[\/]\.(git|hg|svn|rim|bake)$',
"   \ 'file': '\v\.(exe|so|dll|a|stackdump|cmdline|d|o|bake)$',
"   \ }

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


" HeadGuard customization

function! g:HeaderguardName()
    return toupper(expand('%:.:gs/[^0-9a-zA-Z_]/_/g'))
endfunction

" working with TortoiseGit
if has("win16") || has("win32")
    :command! TLog Dispatch! TortoiseGitProc.exe /command:log 
    :command! TLogp Dispatch! TortoiseGitProc.exe /command:log /path:%:p:h
    :command! TLogf Dispatch! TortoiseGitProc.exe /command:log /path:%:p
    :command! TCi Dispatch! TortoiseGitProc.exe /command:commit
endif




"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Start Page routine"""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

fun! Open_item()
    let l:item = expand('<cfile>')
    if isdirectory(l:item)
        exec ":cd " . l:item
        enew
        NERDTree
    else
        exec ":e " . l:item 
        NERDTreeFind
        exec (':wincmd l' )
    endif
endfun
" start page
fun! Start()
    " Don't run if: we have commandline arguments, we don't have an empty
    " buffer, if we've not invoked as vim or gvim, or if we'e start in insert mode
    if argc() || line2byte('$') != -1 || v:progname !~? '^[-gmnq]\=vim\=x\=\%[\.exe]$' || &insertmode
        return
    endif

    " Start a new buffer ...
    enew

    " ... and set some options for it
    setlocal
        \ bufhidden=wipe
        \ buftype=nofile
        \ nobuflisted
        \ nocursorcolumn
        \ nocursorline
        \ nolist
        \ noswapfile
        \ norelativenumber

    " Now we can just write to the buffer, whatever you want.
    "call append('$', "")
    "call append('$', "Open notes")
    ":0r $MYVIMRC/../start.txt
    exec ":0r " . s:vimrc_path . "/start.txt"
    " for line in split(system('fortune -a'), '\n')
    "    call append('$', '        ' . l:line)
    "endfor

    " No modifications to this buffer
    setlocal nomodifiable nomodified

    " When we go to insert mode start a new buffer, and start insert
    nnoremap <buffer><silent> e :enew<CR>
    nnoremap <buffer><silent> i :enew <bar> startinsert<CR>
    "nnoremap <buffer><silent> o :enew <bar> startinsert<CR>
    "nnoremap <buffer><silent> o :cd <cfile> <bar> :enew <bar> :NERDTree<CR>
    nnoremap <buffer><silent> o :call Open_item()<CR>
    nnoremap <buffer><silent> <Enter> :call Open_item()<CR>

    nnoremap <buffer><silent> g1 1gg :call Open_item()<CR>
    nnoremap <buffer><silent> g2 2gg :call Open_item()<CR>
    nnoremap <buffer><silent> g3 3gg :call Open_item()<CR>
    nnoremap <buffer><silent> g4 4gg :call Open_item()<CR>
    nnoremap <buffer><silent> g5 5gg :call Open_item()<CR>
    nnoremap <buffer><silent> g6 6gg :call Open_item()<CR>
    nnoremap <buffer><silent> g7 7gg :call Open_item()<CR>
    nnoremap <buffer><silent> g8 8gg :call Open_item()<CR>
    nnoremap <buffer><silent> g9 8gg :call Open_item()<CR>

endfun

" Run after "doing all the startup stuff"
autocmd VimEnter * call Start()

