
fun LogFold(wordn)
    let foldexpr_cmd = "set foldexpr=get(split(getline(v:lnum-1),':\\ '),".a:wordn.",'')!=get(split(getline(v:lnum),':\\ '),".a:wordn.",'')?'>1':'='"
    execute foldexpr_cmd
    set foldmethod=expr

    " set foldexpr=get(split(getline(v:lnum-1),':\ '),2,'')!=get(split(getline(v:lnum),':\ '),2,'')?'>1':'='
endfun

fun LogColor()
    MarkPalette extended
    silent 19Mark /\cERROR:/
    silent 20Mark /\cWARN:/
    silent 21Mark /\cINFO:/
endfun

" remove duplicate messages (split by `:`, wordn - array index
fun LogRemoveDuplicates(wordn)
    let lnum = 2
    while lnum <= line("$")
        if get(split(getline(lnum-1),':\ '),a:wordn,'1')==get(split(getline(lnum),':\ '),a:wordn,'2')
            execute(":".lnum."d")
        else
            let lnum = lnum + 1
        endif
    endwhile
endfun

fun LogRemoveKnownMessages()
    : %s/\\[.\{-}m//g
    : %g/muted .*CAN/d
    : %g/CAN bus error/d
    : %g/0x46d.*Flow/d
    : %g/ff10.*0x46d/d
    : %g/ff10.*0x46f/d
    : %g/ff10.*0x4046/d
    : %g/ff10.*0x40c6/d
    : %g/ff10.*0x40c5/d
    : %g/ff10.*0x40c4/d
    : %g/ff10.*0x4044/d
    : %g/ff10.*0x407b/d
    : %g/FoDMaster .* TP/d
endfun
