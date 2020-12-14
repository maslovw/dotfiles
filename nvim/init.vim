" set ff=dos
"disable netrw
"let g:loaded_netrw       = 1
"let g:loaded_netrwPlugin = 1
let g:loaded_ctrlp = 1

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
Plug 'junegunn/fzf', { 'do': './install --bin' }
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim' 
" Highlight many 
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-mark'
Plug 'NLKNguyen/papercolor-theme'
Plug 'terryma/vim-multiple-cursors'
call plug#end()

let g:vimrc_path = expand('<sfile>:p:h')

exec "source " . g:vimrc_path . "/esr.vim"
exec "source " . g:vimrc_path . "/bake.vim"


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

nnoremap <silent> <F12> :NERDTreeToggle<CR>
nnoremap <silent> <C-F12> :NERDTreeFind<CR>
nnoremap <silent> <C-Tab> :tabnext<CR>
nnoremap <silent> <C-S-Tab> :tabNext<CR>
nnoremap <silent> <C-T> :tabnew<CR>

" open vertical split from quickfix window 
autocmd! FileType qf nnoremap <buffer> <leader><Enter> <C-w><Enter><C-w>L

nnoremap <Leader>p :FZF <CR>
"nnoremap <C-P> :call fzf#run(fzf#wrap({'source': 'git ls-files', 'options': ['-i', ' -- :(exclude)*cpp']})) <CR>
nnoremap <C-P> :call fzf#run(fzf#wrap({'source': 'rg -S -g !test/ --files'})) <CR>
command! -bang -nargs=* Rg  call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -g \"!test\/\" -g \"!mock\/\" -g !tags ".shellescape(<q-args>), 1, <bang>0)
nnoremap <Leader>ff :Rg <CR>
"nnoremap <Leader>ff  :call fzf#run(fzf#wrap({'source': 'rg -S -g !test/'})) <CR>
"nnoremap <Leader>ff  :call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, <bang>0)'
"nnoremap <Leader>ff  :call fzf#run(fzf#wrap({'source': 'rg -e'})) <CR>
" Git
nnoremap <Leader>fF :Ggrep! <cword> ** ':(exclude)*\/test\/*' ':(exclude)*\/mock\/*' <bar> :copen <CR>
nnoremap <Leader>fG :Ggrep! --no-exclude-standard --untracked <cword> ** <bar> :copen <CR>

" save
nmap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR><ESC>

inoremap <C-Space> <C-x><C-n>

" remove hightlight on next enter after search
nnoremap <silent> <CR> :noh<CR><CR>

cnoremap <C-N> <UP>
cnoremap <C-P> <Down>

" folding
" set foldmethod=syntax
"
set foldmethod=marker
set foldmarker={,}
set foldlevel=1
set nofen " zN to enable

" cursor briefely jumps to the matching brace
set showmatch
set matchtime=3

" set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:·
set listchars=eol:¬,tab:>·,trail:~,precedes:<,space:·
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

" don't jump to the beginning of the file after last search 
set nowrapscan

highlight multiple_cursors_cursor term=reverse cterm=reverse gui=reverse
highlight link multiple_cursors_visual Visual
" automatically scroll at the end/beginning of the screen
set scrolloff=3

if has("win32")
    set rtp+=~\\bin
endif

" temporary files
if has("win32")
    set backupdir=c:\\temp\\vim\\backup\\
    set directory=c:\\temp\\vim\\swp\\
    set undodir=c:\\temp\\vim\\undo\\
    let g:fzf_history_dir = 'c:\\temp\\vim\\fzf_history\\'
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

" show title as two last folders in CWD 
augroup dirchange
    autocmd!
    autocmd DirChanged * let &titlestring=join(split(v:event['cwd'], '\\')[-2:], '/')
augroup END

" *\\tmp\\*,
set wildignore+=*.swp,*.zip,*.exe,*.stackdump,*.o,*.pyc 
if has("win16") || has("win32")
    set wildignore+=.git\\*,.hg\\*,.svn\\*
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

let g:bake_custom_args = "--time -r -j8"


" Open PDF as text using `pdftotxt` tool
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> -
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -csw78


" :%s/\s\+$//e
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

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

"""" FZF

command! -bang -nargs=* FGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

" Switch between Source and Header
command! -bang -nargs=? -complete=dir SwitchSourceHeader
  \ call fzf#vim#gitfiles(
  \   <q-args>, 
  \   {'options': [
  \         '--info=inline',
  \         '--query', substitute(
  \                      substitute(
  \                        substitute(
  \                          expand("%:r"), 
  \                          "src", "",""), 
  \                      "include", "",""),
  \                    "\\", "/", "g") . " .h | .cpp | .hpp | .c",
  \         '--preview', 'head -n 30 {}'
  \   ]}, <bang>0)


" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
" imap <c-x><c-l> <plug>(fzf-complete-line)

inoremap <expr> <c-x><c-l> fzf#vim#complete(fzf#wrap({
  \ 'prefix': '^.*$',
  \ 'source': 'rg -n ^ --color always',
  \ 'options': '--ansi --delimiter : --nth 3..',
  \ 'reducer': { lines -> join(split(lines[0], ':\zs')[2:], '') }}))

nnoremap <C-F2> :SwitchSourceHeader <CR>

"nnoremap <C-P> :call fzf#run(fzf#wrap({'source': 'git ls-files', 'options': '-i'})) <CR>
nnoremap <C-F3> :call fzf#run(fzf#wrap({'source': 'git ls-files', 'options': ['-i', '--query', expand('<cword>')]})) <CR>
"""" >> FZF

" HEX / BIN viewer
nnoremap <F4> :!xxd <CR>
" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END


" if ! exists('g:mwPalettes')	" (Optional) guard if the plugin isn't properly installed.
" finish
" endif

exec "source " . g:vimrc_path . "/log_helper.vim"
" Start Page routine"""""""""""""""""""""""""""""""""""""""""""""""""""""""
exec "source " . g:vimrc_path . "/start.vim"
