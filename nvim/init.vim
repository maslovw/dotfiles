" set ff=dos
"disable netrw
"let g:loaded_netrw       = 1
"let g:loaded_netrwPlugin = 1
set nocompatible
" Some helpers variables to find out where we're executing vim
let s:darwin = has('mac')
let s:windows = has("win32") || has("dos32") || has("win16") || has("dos16") || has("win95") || has("win64")
let s:on_gui = has('gui_running')

let g:loaded_ctrlp = 1

call plug#begin('~/dotfiles/nvim/plugged')
Plug 'vim-airline/vim-airline'
Plug 'rakr/vim-one'
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

"airline status line 

"let g:airline_section_a = g:airline_section_b
let g:airline_section_a = '%-0.10{getcwd()}'
let g:airline_section_y = ''
" 

exec "source " . g:vimrc_path . "/esr.vim"
exec "source " . g:vimrc_path . "/bake.vim"

try
    exec "source " . g:vimrc_path . "/projects/project_specific.vim"
endtry


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text Formatting/Layout
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=4 shiftwidth=4 expandtab
set cinwords+=try,catch
set shiftround " When at 3 spaces and I hit >>, go to 4, not 5.


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text Formatting/Layout
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" set foldmethod=syntax
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

" configs
set wildmenu
set relativenumber
set number
set colorcolumn=120
set ignorecase
set hlsearch
set incsearch
highlight ColorColumn ctermbg=0 guibg=lightgrey
set hidden
set nowrap

" don't jump to the beginning of the file after last search 
set nowrapscan

highlight multiple_cursors_cursor term=reverse cterm=reverse gui=reverse
highlight link multiple_cursors_visual Visual
" automatically scroll at the end/beginning of the screen
set scrolloff=3

" temporary files
if s:windows
    set rtp+=~\\bin
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
"set background=light
set cursorline

set title

" show title as two last folders in CWD 
augroup dirchange
    autocmd!
    autocmd DirChanged * let &titlestring=join(split(v:event['cwd'], '\\')[-2:], '/')
augroup END

" *\\tmp\\*,
set wildignore+=*.swp,*.zip,*.exe,*.stackdump,*.o,*.pyc 
if s:windows
    set wildignore+=.git\\*,.hg\\*,.svn\\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" CtrlP config
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_working_path_mode = 'rwa'
let g:ctrlp_by_filename = 0


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
    autocmd BufWritePre *.md,*.txt,*.js,*.py,*.wiki,*.sh,*.coffee,*.cpp,*.h :call CleanExtraSpaces()
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
if s:windows
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
command! -bang -nargs=? -complete=dir FzfSwitchSourceHeader
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
  \                    "\\", "/", "g") . GetAlternateExtension(),
  \         '--preview', 'head -n 30 {}'
  \   ]}, <bang>0)


function! IsHeader()
    let header_extensions = ['h', 'hh', 'H', 'HH', 'hxx', 'HXX', 'hpp', 'HPP']
    let is_header = (count(header_extensions, expand('%:e')) > 0)

    if is_header
        return 1
    endif

    return 0
endfunction

" Switch from header file to implementation file (and vice versa).
function! SwitchSourceHeader()
    let header_extensions = ['h', 'hpp',  'hh', 'H', 'HH', 'hxx', 'HXX', 'HPP']
    let impl_extensions = ['cpp', 'c', 'mm', 'm', 'C', 'CC']
    let filename = substitute( expand("%:r"), "\\", "/", "g") 

    let filename = substitute(filename, "//", "/", "g") . "."
    if IsHeader()
        let filename = substitute(filename, "include", "src", "g")
        if !HasReadableExtensionIn(filename,  impl_extensions)
            exe 'FzfSwitchSourceHeader'
        endif
    else
        let filename = substitute(filename, "src", "include", "g")
        if !HasReadableExtensionIn(filename, header_extensions)
            exe 'FzfSwitchSourceHeader'
        endif
    endif
endfunction

function! HasReadableExtensionIn(path, extensions)
    for ext in a:extensions
        if filereadable(a:path.ext)
            exe 'e '.fnameescape(a:path.ext)
            return 1
        endif
    endfor
    return 0
endfunction

function! GetAlternateExtension()
    let path = expand('%:p:r').'.'
    "let header_extensions = ['h', 'hh', 'H', 'HH', 'hxx', 'HXX', 'hpp', 'HPP']
    "let impl_extensions = ['m', 'mm', 'c', 'cpp', 'C', 'CC']
    let is_header = IsHeader()

    if !is_header
        return " .h | .hpp "
    endif

    return " .cpp | .c"
endfunction

command! -bang -nargs=? -complete=dir FindFile
  \ call fzf#vim#gitfiles(
  \   <q-args>, 
  \   {'options': [
  \         '--info=inline',
  \         '--query', "'" . substitute(
  \                        substitute(
  \                        substitute(
  \                        substitute(
  \                          expand("<cWORD>"), 
  \                      "<", "","g"),
  \                      ">", "","g"),
  \                      "\"", "","g"),
  \                    "\\", "/", "g"),
  \         '--preview', 'head -n 30 {}'
  \   ]}, <bang>0)

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
"

" KEY MAPPING

let mapleader = ","
" Key maps
" remap jk to ESC
inoremap jk <ESC>
" paste from global buf
nnoremap <S-Insert> "+p
" copy from global buf
vnoremap <C-Insert> "+y

" copy relative path
nnoremap yp :let @" = substitute(expand("%"), '\\', '/', 'g')<CR>
" copy full path
nnoremap yP :let @" = substitute(expand("%:p"), '\\', '/', 'g')<CR>
" copy file name
nnoremap yf :let @" = substitute(expand("%:t"), '\\', '/', 'g')<CR>

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
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -g \"!test\/\" -g \"!mock\/\" -g !tags ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
nnoremap <Leader>ff :Rg <CR>
"nnoremap <Leader>ff  :call fzf#run(fzf#wrap({'source': 'rg -S -g !test/'})) <CR>
"nnoremap <Leader>ff  :call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, <bang>0)'
"nnoremap <Leader>ff  :call fzf#run(fzf#wrap({'source': 'rg -e'})) <CR>
"
command! CtagsUpdate :execute "!ctags --exclude=test --exclude=mock -R *"
" Git search of a word under cursor
nnoremap <Leader>fF :Ggrep! <cword> ** ':(exclude)*\/test\/*' ':(exclude)*\/mock\/*' <bar> :copen <CR> <C-W>J
" Git search of selected text
vnoremap <Leader>fF y:Ggrep! "<C-R>=escape(@",'/\')<CR>" ** ':(exclude)*\/test\/*' ':(exclude)*\/mock\/*' <bar> :copen <CR> <C-W>J
" Git search untracked word under cursor
nnoremap <Leader>fG :Ggrep! --no-exclude-standard --untracked <cword> ** <bar> :copen <CR>
" Git search a word under cursor ignoring current file
nnoremap <Leader>fd :Ggrep! <cword> ** ':(exclude)*\/'%:t ':(exclude)*\/test\/*' ':(exclude)*\/mock\/*' <bar> :copen <CR> <C-W>J

"Now when we run :grep inside Vim, it will run rg --vimgrep --smart-case --follow instead
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
" search selected text
vnoremap * y/\V<C-R>=escape(@",'/\')<CR><CR>

"vnoremap <C-P> ""yi" :call fzf#run(fzf#wrap({'source': 'rg -S -g !test/ --files', 'options': '-q' . expand('<cword>')})) <CR> 


" save 
nmap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR><ESC>

inoremap <C-Space> <C-x><C-n>

" remove hightlight on next enter after search
nnoremap <silent> <CR> :noh<CR><CR>

cnoremap <C-N> <UP>
cnoremap <C-P> <Down>
nnoremap <C-F2> :call SwitchSourceHeader() <CR>
nnoremap <F3> :FindFile <CR>

nnoremap <C-F3> :call fzf#run(fzf#wrap({'source': 'git ls-files', 'options': ['-i', '--query', expand('<cword>')]})) <CR>
"""" >> FZF

" HEX / BIN viewer
nnoremap <F4> :!xxd <CR>
" change decimal and hex numbers under cursor
nnoremap gn :call DecAndHex(expand("<cword>"))<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Helper functions
"     These functions are used on some mappings.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction


" change number under cursor hex<->dec
function! DecAndHex(number)
  let ns = '[.,;:''"<>(){}\[\]^_U]'      " number separators
  if a:number =~? '^' . ns. '*[-+]\?\d\+' . ns . '*$'
     "dec to hex
     let dec = substitute(a:number, '[^0-9+-]*\([+-]\?\d\+\).*','\1','')
     let old = @"
     let @" = printf('0x%02X', dec)
     execute "normal! viwp"
     echo dec . printf('  ->  0x%X, 0b%08b', dec, dec)
     let @" = old
 elseif a:number =~? '^\w*' . ns. '*\(0x\|#\)\(\x\+\)' . ns . '*$'
     "hex to dec
     let hex = substitute(a:number, '.\{-}\%\(0x\|#\)\(\x\+\).*','\1','')
     let old = @"
     let @" = printf('%d', eval('0x'.hex))
     execute "normal! viwp"
     echo '0x' . hex . printf('  ->  %d', eval('0x'.hex))
     let @" = old
  else
     echo "NaN"
  endif
endfunction
" Loading extran .vim

exec "source " . g:vimrc_path . "/log_helper.vim"
" Start Page routine"""""""""""""""""""""""""""""""""""""""""""""""""""""""
exec "source " . g:vimrc_path . "/start.vim"
