" aliases
" S32G 
command! BuildS32 :Bake --time -r -j8 --abs-paths -m c:/work/s32g_eval/code/s32g-poc/CM7A/application -b DebugApplicationCm7a --adapt arm32_ewl2
"
" cgw3 
command! BuildCgw3Gateway :Bake --time -r -j8 --abs-paths -m application/workspacez4B/gateway 
command! BuildCgw3Application :Bake --time -r -j8 --abs-paths -m application/workspacez4A/applicationMc 
