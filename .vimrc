filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
filetype plugin indent on
set nocompatible
set modelines=0
set nowrap
set hidden
set expandtab
set textwidth=0
set tabstop=8
set softtabstop=4
set shiftwidth=4
set autoindent
set hlsearch
set tags=tags,/home/mcordial/pyenvs/asurepo/lib/python2.7/site-packages/tags,/home/mcordial/pyenvs/src/tags
syntax on
" nmap <silent> <c-t> :TlistToggle<CR>
nmap <silent> <c-q> :NERDTreeToggle<CR>
nmap <silent> <c-h> :noh<CR>
nmap <silent> <c-n> :bn<CR>
nmap <silent> <c-k> :bp<CR>
nmap <silent> <c-p> :b#<CR>
nmap ,s :Gstatus<CR>
nmap ,c :Gcommit<CR>
highlight SpellBad term=underline gui=undercurl guisp=Orange 

" Add the virtualenv's site-packages to vim path
py << EOF
import os.path
import sys
import vim
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

