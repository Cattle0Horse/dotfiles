let mapleader = "\<space>"

set ignorecase
set smartcase
set hlsearch


"删除设置(不要将删除内容放入剪贴板, 未处理c和delete操作)
nnoremap dd    "_dd
nnoremap daw   "_daw
nnoremap dw    "_dw
nnoremap D     "_D
nnoremap dh"   "_di"
nnoremap dhw   "_diw
nnoremap dh(   "_di(
nnoremap dh{   "_di{
nnoremap x     "_x
nnoremap s     "_s
nnoremap S     "_S


vnoremap d     "_d
vnoremap dd    "_dd
vnoremap daw   "_daw
vnoremap dw    "_dw
vnoremap D     "_D
vnoremap dh"   "_di"
vnoremap dhw   "_diw
vnoremap dh(   "_di(
vnoremap dh{   "_di{
vnoremap s     "_s
vnoremap S     "_S


"在visual 模式里粘贴不要复制
vnoremap p "_dP

" 使回格键（backspace）正常处理indent, eol, start等
" set backspace=2
