" Add ESR Labs Copyright header
fun! CopyrightAdd()
  :0r $MYVIMRC/../esr.copyright
  :0,3s/%YEAR%/\=strftime('%Y')/g
endfun
