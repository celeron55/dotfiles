" Plugins
" - rust.vim
" - vim-fswitch

" This should generally come first
set nocompatible

" First load pathogen plugins if they exist
silent! call pathogen#infect()

" Then continue with regular stuff
set tabstop=4
set shiftwidth=4
syntax on
set background=dark
set indentexpr=on
set softtabstop=4
set wildmode=longest,list
set belloff=all,backspace
" Disable parenthesis matching
"let loaded_matchparen = 1
map - :tabnext<CR>
map . :tabprev<CR>
"map , :wincmd w<CR>
"imap CTRL-- :tabnext<CR>
"imap CTRL-. :tabprev<CR>
"imap  :wincmd w<CR>
"set mouse=a
"set expandtab
set scrolloff=1000
set ai
set copyindent
set tabpagemax=50
set list lcs=nbsp:_
set nolist
set history=200

" F2, number[enter] opens buffer list and switches to buffer
:nnoremap <F2> :buffers<CR>:buffer<Space>

" Command for opening cpp and h to a new tab in a vsplit view
command! -nargs=1 -complete=file HCC let f=fnamemodify("<args>", ":r") | let $h = f . ".h"   | let $c = f . ".cpp" | tabnew $h | vsplit $c
command! -nargs=1 -complete=file HPP let f=fnamemodify("<args>", ":r") | let $h = f . ".hpp" | let $c = f . ".cpp" | tabnew $h | vsplit $c
command! -nargs=1 -complete=file HC  let f=fnamemodify("<args>", ":r") | let $h = f . ".h"   | let $c = f . ".c"   | tabnew $h | vsplit $c
"command! -nargs=1 HCC tabnew <args>.cpp | vsplit <args>.h
"command! -nargs=1 HC tabnew <args>.c | vsplit <args>.h
command! -nargs=1 HHCC tabnew src/<args>.cpp | vsplit include/<args>.h
command! -nargs=1 HHC tabnew src/<args>.c | vsplit include/<args>.h

" Some kind of commands that will open the corresponding header or source
" file in a newly made vsplit (vim-fswitch)
:nnoremap <F3> :FSSplitLeft<CR>
:nnoremap <F4> :FSSplitRight<CR>

" The way Minetest and others are organized - no separate include alongside src
au! BufEnter *.cpp let b:fswitchdst = 'h,hpp' | let b:fswitchlocs = '.'
au! BufEnter *.h   let b:fswitchdst = 'c,cpp' | let b:fswitchlocs = '.'

" Use this for projects that have src and include
function! FSinclude_along_src()
    au! BufEnter *.cpp let b:fswitchdst = 'h,hpp' | let b:fswitchlocs = 'reg:/src/include/,reg:|src|include/**|,ifrel:|/src/|../include|'
    au! BufEnter *.h   let b:fswitchdst = 'c,cpp' | let b:fswitchlocs = 'reg:/include/src/,reg:/include.*/src/,ifrel:|/include/|../src|'
endfunction

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
au! BufEnter * match NbSpace / /
" Hilight other suspicious spaces
hi LeadingSpace ctermbg=darkgrey
au! BufEnter * match LeadingSpace /^ \+/
hi TrailingSpace ctermbg=darkgrey
au! BufEnter * match TrailingSpace / \+$/

" gvim stuff
if has("gui_running")
	" dark color scheme
	:colorscheme torte
endif

" Don't auto-wrap text
set formatoptions-=t

" Don't autoinsert comments
autocmd FileType * setlocal formatoptions-=r formatoptions-=o tw=80

" Some random shit to make dart files to be syntax hilighted according to
" ~/.vim/syntax/dart.vim
if has("syntax")
	filetype on
	au BufNewFile,BufRead *.dart set filetype=dart
endif

"
" File format specific configurations
"

" Format-specific stuff
" PHP is usually space-indented... but comment out for now
"autocmd FileType php setlocal expandtab
" yaml is always space-indented
autocmd FileType yaml setlocal expandtab

" Shorthand for expandtab
command! E setlocal expandtab | setlocal shiftwidth=4 | setlocal softtabstop=4 | setlocal tabstop=4
command! E4 setlocal expandtab | setlocal shiftwidth=4 | setlocal softtabstop=4 | setlocal tabstop=4
command! E3 setlocal expandtab | setlocal shiftwidth=3 | setlocal softtabstop=3 | setlocal tabstop=3
command! E2 setlocal expandtab | setlocal shiftwidth=2 | setlocal softtabstop=2 | setlocal tabstop=2
" Shorthand for noexpandtab
command! NE setlocal noexpandtab | setlocal shiftwidth=4 | setlocal softtabstop=4 | setlocal tabstop=4

" Save session automatically so that restoring from crashes is easy
autocmd BufWrite * mkses! .session.vim.auto

" .lzz is C++
au BufRead,BufNewFile *.lzz set filetype=cpp
" .less is css
au BufRead,BufNewFile *.less set filetype=css
" .ino is C++
au BufRead,BufNewFile *.ino set filetype=cpp

" Use some magic to handle certain projects better: This function allows
" changing syntax hilighting within predefined delimiters
function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
  let ft=toupper(a:filetype)
  let group='textGroup'.ft
  if exists('b:current_syntax')
    let s:current_syntax=b:current_syntax
    " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
    " do nothing if b:current_syntax is defined.
    unlet b:current_syntax
  endif
  execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
  try
    execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
  catch
  endtry
  if exists('s:current_syntax')
    let b:current_syntax=s:current_syntax
  else
    "unlet b:current_syntax
  endif
  execute 'syntax region textSnip'.ft.'
  \ matchgroup='.a:textSnipHl.'
  \ start="'.a:start.'" end="'.a:end.'"
  \ contains=@'.group
endfunction

call TextEnableCodeSnip('javascript', '#ifdef ASPECT_JAVASCRIPT_UI', '#endif', 'SpecialComment')

autocmd FileType html call TextEnableCodeSnip('javascript', '{{', '}}', 'SpecialComment')

function! DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
endfunction
command! DeleteHiddenBuffers call DeleteHiddenBuffers()
command! DHB call DeleteHiddenBuffers()
