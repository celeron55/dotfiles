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
command! -nargs=1 -complete=file HCC let f=fnamemodify("<args>", ":r") | let $h = f . ".h" | let $c = f . ".cpp" | tabnew $h | vsplit $c
command! -nargs=1 -complete=file HC  let f=fnamemodify("<args>", ":r") | let $h = f . ".h" | let $c = f . ".c"   | tabnew $h | vsplit $c
"command -nargs=1 HCC tabnew <args>.cpp | vsplit <args>.h
"command -nargs=1 HC tabnew <args>.c | vsplit <args>.h
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

" Highlight non-breaking spaces
hi NbSpace ctermbg=red
match NbSpace / /

" Format-specific stuff
"autocmd FileType php setlocal expandtab
"autocmd FileType php echo "NOTE: File format is PHP -> expandtab has been enabled; run NE to disable"
command NE setlocal noexpandtab

" gvim stuff
if has("gui_running")
	" dark color scheme
	:colorscheme torte
endif
" Some random shit to make dart files to be syntax hilighted according to
" ~/.vim/syntax/dart.vim
if has("syntax")
	filetype on
	au BufNewFile,BufRead *.dart set filetype=dart
endif
" Don't auto-wrap text
set formatoptions-=t
" Don't autoinsert comments
autocmd FileType * setlocal formatoptions-=r formatoptions-=o tw=80
autocmd FileType yaml setlocal expandtab
"autocmd FileType yaml echo "NOTE: File format is YAML -> expandtab has been enabled; run NE to disable"
" Save session automatically so that restoring from crashes is easy
autocmd WinEnter * mkses! session.vim.auto
