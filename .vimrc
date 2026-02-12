" ==================================================
" 基础设置
" ==================================================

set nocompatible
set incsearch
set hlsearch
set ignorecase
set smartcase
set clipboard=unnamedplus
set number
set relativenumber
set cursorline
set showcmd
set foldlevel=99

let mapleader=" "


" ==================================================
" 无循环方向键映射
" i=上 k=下 j=左 l=右
" ==================================================

" Normal 模式
nnoremap i <Up>
nnoremap k <Down>
nnoremap j <Left>
nnoremap l <Right>

" 到行首（非空白）
nnoremap J ^
" 到行尾
nnoremap L $

" 向上移动5行
nnoremap I 5<Up>
" 向下移动5行
nnoremap K 5<Down>

" Visual 模式
vnoremap i <Up>
vnoremap k <Down>
vnoremap j <Left>
vnoremap l <Right>

vnoremap J ^
vnoremap L $

vnoremap I 5<Up>
vnoremap K 5<Down>

" Operator-pending 模式
onoremap i <Up>
onoremap k <Down>
onoremap j <Left>
onoremap l <Right>

onoremap J ^
onoremap L $


" ==================================================
" 插入模式入口
" ==================================================

" h 进入插入模式
nnoremap h i
vnoremap h i
onoremap h i

" H 行首插入
nnoremap H I
vnoremap H I


" ==================================================
" 屏幕滚动控制
" ==================================================

" 当前行到屏幕顶部
nnoremap zi zt
" 当前行到屏幕底部
nnoremap zk zb
vnoremap zi zt
vnoremap zk zb


" ==================================================
" Tab 页面切换
" ==================================================

nnoremap <C-j> :tabprevious<CR>
nnoremap <C-l> :tabnext<CR>
vnoremap <C-j> :tabprevious<CR>
vnoremap <C-l> :tabnext<CR>


" ==================================================
" 搜索相关
" ==================================================

nnoremap <leader>n :nohlsearch<CR>
vnoremap <leader>n :nohlsearch<CR>


" ==================================================
" 文件保存
" ==================================================

nnoremap <leader>w :w<CR>


" ==================================================
" 合并行
" ==================================================

nnoremap Q J
vnoremap Q J


" ==================================================
" 删除不进入剪贴板（黑洞寄存器）
" ==================================================

" Normal 模式
nnoremap d "_d
nnoremap dd "_dd
nnoremap dw "_dw
nnoremap daw "_daw
nnoremap D "_D
nnoremap x "_x
nnoremap s "_s
nnoremap S "_S

" Visual 模式
vnoremap d "_d
vnoremap D "_D
vnoremap s "_s
vnoremap S "_S

" Delete 键
nnoremap <Delete> "_d
vnoremap <Delete> "_d
onoremap <Delete> "_d


" ==================================================
" 向上 / 向下复制行
" ==================================================

" 向下复制当前行
nnoremap <leader>ck :t.<CR>
" 向上复制当前行
nnoremap <leader>ci :t-1<CR>

vnoremap <leader>ck :t'>+0<CR>gv
vnoremap <leader>ci :t'<-1<CR>gv


" ==================================================
" 折叠控制
" ==================================================

" 切换折叠
nnoremap zf za


" ==================================================
" Quickfix 错误跳转
" ==================================================

nnoremap <leader>gi :cprev<CR>
nnoremap <leader>gk :cnext<CR>


" ==================================================
" 简单格式化（缩进）
" ==================================================

nnoremap <leader>fd gg=G


" ==================================================
" 其他推荐
" ==================================================

set timeoutlen=300
set scrolloff=5
set sidescrolloff=5


" =========================
" 主题设置
" =========================

syntax on
set termguicolors
set background=dark
colorscheme habamax
