" Add ESR Labs Copyright header
fun! CopyrightAdd()
  :0r $MYVIMRC/../esr.copyright
  :0,3s/%YEAR%/\=strftime('%Y')/g
endfun

fun! T32StackTrace_historyData()
  : %g!/\*ST\*/d
  : %s/.*\*ST//g
  : %s/\s.*//g
  : %s/\*/\rd.l /g
  : g/^/m0
endfun
