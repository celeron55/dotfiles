set nocompatible
set tabstop=4
set shiftwidth=4
syntax on
set background=dark
set indentexpr=on
set softtabstop=4
" Disable parenthesis matching
"let loaded_matchparen = 1
map - :tabnext<CR>
map . :tabprev<CR>
map , :wincmd w<CR>
"imap CTRL-- :tabnext<CR>
"imap CTRL-. :tabprev<CR>
"imap  :wincmd w<CR>
" Command for opening cpp and h to a new tab in a vsplit view
command -nargs=1 HCC tabnew <args>.cpp | vsplit <args>.h
command -nargs=1 HC tabnew <args>.c | vsplit <args>.h
command -nargs=1 HHCC tabnew src/<args>.cpp | vsplit include/<args>.h
command -nargs=1 HHC tabnew src/<args>.c | vsplit include/<args>.h
"set mouse=a
"set expandtab
set scrolloff=1000
set ai
set copyindent
set tabpagemax=50
set list lcs=nbsp:_
set nolist
" Open definition in new tab
"map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map ´ :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" Open definition in vertical split
"map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
let g:clang_user_options='|| exit 0'
let g:clang_complete_auto=0
au WinEnter * checktime

" Format-specific stuff
"autocmd FileType php setlocal expandtab
"autocmd FileType php echo "NOTE: File format is PHP -> expandtab has been enabled; run NE to disable"
command! NE setlocal noexpandtab
