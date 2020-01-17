"""
" s:bake_make_cmd contains executable command (:make or :Make)
" s:bake_args contains latest bake arguments (automatically reassigned)
" g:bake_custom_args: additional arguments for bake
" let s:bake_current_project = " "
"""

if exists('g:bake_loaded')
    finish
endif

let g:bake_loaded = 1

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

" Detect if Dispatch plugin installed to use :Make
autocmd VimEnter * if exists(':Make') == 2 | let s:bake_make_cmd = "Bake " | else | let s:bake_make_cmd = "Bake " | endif
" autocmd VimEnter * if exists(':Make') == 2 | let s:bake_make_cmd = "Make " | else | let s:bake_make_cmd = "make " | endif


let g:bake_custom_args = ""

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
    res = _find_closest_project_meta(vim.eval('expand("%:ph")'))
    cur_project = res.replace(os.sep, posixpath.sep)
    vim.command('let g:bake_cur_prj = "{}"'.format(cur_project))
    return res

def BakeGetCurrentLib(libConfig=None, options=None):
    vim.command('unlet! s:bake_args')
    PM = BakeFindCurrentProjectPath()
    if PM is None: 
        return 1
    cmd = "--abs-paths -r -m {} ".format(PM.replace(os.sep, posixpath.sep))
    if libConfig:
        cmd += "-b {} ".format(libConfig)
    if options: 
        cmd += "{} ".format(options)
    vim.command('let s:bake_args = "{}"'.format(cmd))
    return cmd

def BakeGetCurrentUnitTest(adapt):
    return BakeGetCurrentLib('UnitTestBase', "--do run --adapt {}".format(adapt))

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
    vim.command('let s:bake_includes = "{}"'.format(s))
    return s

# bakeListStr - output of `bake --list`
def BakeGetListConfigs(bakeListStr):
    # vim.command('let s:bake_current_config_list = "{}"'.format(bakeListStr))
    # return bakeListStr
    res = []
    for line in bakeListStr.splitlines():
        try:
            s = line.split()
            if s[0].startswith('*'):
                if 'default' in line: 
                    res.insert(0, s[1])
                else:
                    res.append(s[1]) # LibConfig is one word, cut `*` and (default)
        except:
            pass

    vim.command('let s:bake_current_config_list = "{}"'.format("\n".join(res)))
    return None
    
endpython

fun! BakeGetArgs()
    return s:bake_make_cmd . " " . g:bake_custom_args . " " . s:bake_args 
endfun

fun! BakeBuildThis()
    py3 BakeGetCurrentLib(vim.eval('expand("<cword>")'))
    let cmd = BakeGetArgs()
    return ':'.cmd
endfun

fun! BakeBuildUnitTest()
    py3 BakeGetCurrentUnitTest("googletest")
    let cmd = s:bake_make_cmd . s:bake_args . " " . g:bake_custom_args
    return ':'.cmd
endfun

fun! BakeBuildLast() abort
    if !exists('s:bake_args')
        py3 BakeGetCurrentUnitTest("")
    endif
    " let cmd = s:bake_make_cmd . s:bake_args . " " . g:bake_custom_args
    let cmd = BakeGetArgs()
    return ':'.cmd
endfun

fun! BakeUpdatePath() abort
    "let s:bake_incs_and_defs_json = system("bake --incs-and-defs=json " . s:bake_args)
    let s:bake_incs_and_defs_json = tempname()
    try
        let s:bake_result = system("bake --incs-and-defs=json " . s:bake_args . " " . g:bake_custom_args . " > " . s:bake_incs_and_defs_json)
        if filereadable(s:bake_incs_and_defs_json)
            py3 BakeGetIncludes(vim.eval('s:bake_incs_and_defs_json'))
            let &path = s:bake_includes
        else
            echo "Error: bake didn't generate json: " . s:bake_result
        endif 
    finally
        call delete(s:bake_incs_and_defs_json)
    endtry
    "let &path = execute("py3 BakeGetIncludes(vim.eval('s:bake_incs_and_defs_json'))")
endfun

nmap <expr> <C-F9> BakeBuildUnitTest()

" Build with last used arguments
" nmap <F9> :exe "make " . s:bake_args <cr>
nmap <expr> <F9> BakeBuildLast()
nmap <expr> <F8> BakeBuildThis()

nmap  <F2> :call BakeUpdatePath()<cr>

fun! BakeCmd(args)
    let s:bake_args = substitute(trim(a:args), g:bake_custom_args, "", "")
    echo (BakeGetArgs())
endfun

command -nargs=1 -complete=custom,ListConfigs Bake call BakeCmd(<f-args>)

fun ListConfigs(A,L,P)
    py3 BakeFindCurrentProjectPath()
    let s:bake_list = system("bake --list -m " . g:bake_cur_prj . " " . g:bake_custom_args)
    py3 BakeGetListConfigs(vim.eval('s:bake_list'))
    "return "sample"
    return s:bake_current_config_list
endfun

