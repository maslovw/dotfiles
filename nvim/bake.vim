if exists('g:loaded_myplugin')
"finish
endif

let g:loaded_myplugin = 1

fun! BakeGetCurrentProject()

endfun

" Bake: diab error
set errorformat=\"%f\"\\,\ line\ %l:\ %s\ %trror\ %m
set errorformat+=\"%f\"\\,\ line\ %l:\ %trror\ %m
set errorformat+=\"%f\"\\,\ line\ %l:\ %twarn\ %m
" Bake: gcc error
set errorformat+=%f:%l:%c:%m
"set errorformat+=
" %f(%l) \=: %t%*\D%n: %m
" %*[^"]"%f"%*\D%l: %m
" %f(%l) \=: %m
" %*[^ ] %f %l: %m
" %f(%l):%m
" %f:%l:%m
" %f|%l| %m
set makeprg=bake

" Make sure Python is ready
if !has("python3")
  echo "vim has to be compiled with +python3 to run this"
  finish
endif

"""
" g:bake_args contains latest bake arguments

"""


py3 << endpython

import vim, os, posixpath, sys, json

def _joinPM(path):
    return os.path.join(path, 'Project.meta')

def _find_closest_project_meta(path):
    full_path = os.path.abspath(path)
    if os.path.isfile(full_path):
        full_path = os.path.dirname(full_path)

    if os.path.isfile(_joinPM(full_path)):
        return full_path
    while len(os.path.split(full_path)[1]) :
        full_path = os.path.dirname(full_path)
        if os.path.isfile(_joinPM(full_path)):
            return full_path
    return None

def BakeFindCurrentProjectPath():
    return _find_closest_project_meta(vim.eval('expand("%:ph")'))

def BakeGetCurrentLib(libConfig=None, options=None):
    vim.command('unlet! g:bake_args')
    PM = BakeFindCurrentProjectPath()
    if PM is None: 
        return 1
    cmd = "--abs-paths -r -m {} ".format(PM.replace(os.sep, posixpath.sep))
    if libConfig:
        cmd += "-b {} ".format(libConfig)
    if options: 
        cmd += "{} ".format(options)
    vim.command('let g:bake_args = "{}"'.format(cmd))
    return cmd

def BakeGetCurrentUnitTest(adapt):
    return BakeGetCurrentLib('UnitTestBase', "--do run --adapt {}".format(adapt))
    #    vim.command('unlet! g:bake_args')
    #    PM = BakeFindCurrentProjectPath()
    #    if PM is None: 
    #        return 1
    #    cmd = "--abs-paths -r --do run -m {} -b UnitTestBase --adapt {} ".format(PM.replace(os.sep, posixpath.sep), adapt)
    #    vim.command('let g:bake_args = "{}"'.format(cmd))
    #    return cmd

def _call_bake(args):
    if sys.platform == 'win32':
        pass
        # subprocess.


def BakeGetIncludes(json_file_name):
    j = json.load(open(json_file_name, "r"))
    incs = set()
    for lib,fields in j.items():
        for field, items in fields.items():
            if field == 'includes':
                incs.update(items)
    if len(incs) == 0: 
        return ""
    s = ",".join(incs)
    s.strip()
    s.replace(' ', '\ ')
    s.replace('/', '\\ ')
    vim.command('let g:bake_includes = "{}"'.format(s))
    return s
endpython

fun! BakeBuildThis()
    py3 BakeGetCurrentLib(vim.eval('expand("<cword>")'))
    let cmd = "make " . g:bake_args
    return ':'.cmd
endfun

fun! BakeBuildUnitTest()
    py3 BakeGetCurrentUnitTest("googletest")
    let cmd = "make " . g:bake_args
    return ':'.cmd
endfun

fun! BakeBuildLib(lib)
    py3 BakeGetCurrentUnitTest("googletest")
    let cmd = "make " . g:bake_args
    return ':'.cmd
endfun

fun! BakeBuildLast() abort
    if !exists('g:bake_args')
        py3 BakeGetCurrentUnitTest("")
    endif
    let cmd = "make " . g:bake_args
    return ':'.cmd
endfun

fun! BakeUpdatePath() abort
    "let s:bake_incs_and_defs_json = system("bake --incs-and-defs=json " . g:bake_args)
    let g:bake_incs_and_defs_json = tempname()
    try
        let s:bake_result = system("bake --incs-and-defs=json " . g:bake_args . " > " . g:bake_incs_and_defs_json)
        if filereadable(g:bake_incs_and_defs_json)
            py3 BakeGetIncludes(vim.eval('g:bake_incs_and_defs_json'))
            let &path = g:bake_includes
        else
            echo "Error: bake didn't generate json: " . s:bake_result
        endif 
    finally
        call delete(g:bake_incs_and_defs_json)
    endtry
    "let &path = execute("py3 BakeGetIncludes(vim.eval('s:bake_incs_and_defs_json'))")
endfun

nmap <expr> <C-F9> BakeBuildUnitTest()

" Build with last used arguments
" nmap <F9> :exe "make " . g:bake_args <cr>
nmap <expr> <F9> BakeBuildLast()
nmap <expr> <F8> BakeBuildThis()

nmap  <F2> :call BakeUpdatePath()<cr>
