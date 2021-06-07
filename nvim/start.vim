
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
        " NERDTreeFind
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
    exec ":0r " . g:vimrc_path . "/start.txt"
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
