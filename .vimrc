"vim:set ts=8 sts=2 sw=2 tw=0 
"
" An example for a Japanese version vimrc file.
" 日本語版のデフォルト設定ファイル(vimrc) - Vim7用試作
"
"
" Last Change: 15-Apr-2016.
" Maintainer:  RailsInstall <railsinstall@gmail.com>
"
" 解説:
" このファイルにはVimの起動時に必ず設定される、編集時の挙動に関する設定が書
" かれています。GUIに関する設定はgvimrcに書かかれています。
"
" 個人用設定は_vimrcというファイルを作成しそこで行ないます。_vimrcはこのファ
" イルの後に読込まれるため、ここに書かれた内容を上書きして設定することが出来
" ます。_vimrcは$HOMEまたは$VIMに置いておく必要があります。$HOMEは$VIMよりも
" 優先され、$HOMEでみつかった場合$VIMは読込まれません。
"
" 管理者向けに本設定ファイルを直接書き換えずに済ませることを目的として、サイ
" トローカルな設定を別ファイルで行なえるように配慮してあります。Vim起動時に
" サイトローカルな設定ファイル($VIM/vimrc_local.vim)が存在するならば、本設定
" ファイルの主要部分が読み込まれる前に自動的に読み込みます。
"
" 読み込み後、変数g:vimrc_local_finishが非0の値に設定されていた場合には本設
" 定ファイルに書かれた内容は一切実行されません。デフォルト動作を全て差し替え
" たい場合に利用して下さい。
"
" 参考:
"   :help vimrc
"   :echo $HOME
"   :echo $VIM
"   :version

"---------------------------------------------------------------------------
" サイトローカルな設定($VIM/vimrc_local.vim)があれば読み込む。読み込んだ後に
" 変数g:vimrc_local_finishに非0な値が設定されていた場合には、それ以上の設定
" ファイルの読込を中止する。
if 1 && filereadable($VIM . '/vimrc_local.vim')
  unlet! g:vimrc_local_finish
  source $VIM/vimrc_local.vim
  if exists('g:vimrc_local_finish') && g:vimrc_local_finish != 0
    finish
  endif
endif

"---------------------------------------------------------------------------
" ユーザ優先設定($HOME/.vimrc_first.vim)があれば読み込む。読み込んだ後に変数
" g:vimrc_first_finishに非0な値が設定されていた場合には、それ以上の設定ファ
" イルの読込を中止する。
if 0 && exists('$HOME') && filereadable($HOME . '/.vimrc_first.vim')
  unlet! g:vimrc_first_finish
  source $HOME/.vimrc_first.vim
  if exists('g:vimrc_first_finish') && g:vimrc_first_finish != 0
    finish
  endif
endif

"---------------------------------------------------------------------------
" 日本語対応のための設定:
"
" ファイルを読込む時にトライする文字エンコードの順序を確定する。漢字コード自
" 動判別機能を利用する場合には別途iconv.dllが必要。iconv.dllについては
" README_j.txtを参照。ユーティリティスクリプトを読み込むことで設定される。
"source $VIM/encode_japan.vim
if filereadable($VIM . '/plugins/kaoriya/encode_japan.vim')
  source $VIM/plugins/kaoriya/encode_japan.vim
elseif filereadable('/usr/local/share/vim/encode_japan.vim')
  source /usr/local/share/vim/encode_japan.vim
endif

" メッセージを日本語にする (Windowsでは自動的に判断・設定されている)
if !(has('win32') || has('mac')) && has('multi_lang')
  if !exists('$LANG') || $LANG.'X' ==# 'X'
    if !exists('$LC_CTYPE') || $LC_CTYPE.'X' ==# 'X'
      language ctype ja_JP.eucJP
    endif
    if !exists('$LC_MESSAGES') || $LC_MESSAGES.'X' ==# 'X'
      language messages ja_JP.eucJP
    endif
  endif
endif
" MacOS Xメニューの日本語化 (メニュー表示前に行なう必要がある)
if has('mac')
  set langmenu=japanese
endif
" 日本語入力用のkeymapの設定例 (コメントアウト)
if has('keymap')
  " ローマ字仮名のkeymap
  "silent! set keymap=japanese
  "set iminsert=0 imsearch=0
endif
" 非GUI日本語コンソールを使っている場合の設定
if !has('gui_running') && &encoding != 'cp932' && &term == 'win32'
  set termencoding=cp932
endif

"---------------------------------------------------------------------------
" メニューファイルが存在しない場合は予め'guioptions'を調整しておく
if 1 && !filereadable($VIMRUNTIME . '/menu.vim') && has('gui_running')
  set guioptions+=M
endif

"---------------------------------------------------------------------------
" Bram氏の提供する設定例をインクルード (別ファイル:vimrc_example.vim)。これ
" 以前にg:no_vimrc_exampleに非0な値を設定しておけばインクルードはしない。
if 1 && (!exists('g:no_vimrc_example') || g:no_vimrc_example == 0)
  source $VIMRUNTIME/vimrc_example.vim
endif

"---------------------------------------------------------------------------
" 検索の挙動に関する設定:
"
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase

"---------------------------------------------------------------------------
" 編集に関する設定:
"
" タブの幅
set tabstop=2
set softtabstop=2
set shiftwidth=2
set modelines=3
" タブをスペースに展開しない (expandtab:展開する)
set expandtab
" インデントはスマートインデント
set smartindent
" 自動的にインデントする (noautoindent:インデントしない)
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=2
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set nowrapscan
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
" コマンドライン補完をシェルっぽく
set wildmode=list:longest
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM
" 日本語整形スクリプト(by. 西岡拓洋さん)用の設定
let format_allow_over_tw = 1	" ぶら下り可能幅
" 選択した文字をクリップボードに入れる
set clipboard=unnamed
" 保存していなくても別のファイルを表示できるようにする
set hidden
" 編集中のファイルが変更されたら自動で読み直す
set autoread

"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 行番号を非表示 (number:表示)
set number
" ルーラーを表示 (noruler:非表示)
set ruler
" タブや改行を表示 (list:表示)
set nolist
" どの文字でタブや改行を表示するかを設定
"set listchars=tab:>-,eol:<
"set listchars=tab:>-,extends:<,trail:-,eol:<
" 長い行を折り返して表示 (nowrap:折り返さない)
set wrap
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=1
" コマンドをステータス行に表示
set showcmd
" タイトルを非表示
set notitle


"---------------------------------------------------------------------------
" ファイル操作に関する設定:
"
" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
"set nobackup
if $TMP==""
  let $TMP="/tmp"
endif
" バックアップファイルを環境変数TMPで指定されたディレクトリに作成
set backupdir=$TMP
" バックアップファイルの拡張子を.bakに設定
set backupext=.bak
" スワップファイルを環境変数TMPで指定されたディレクトリに作成
set directory=$TMP

set undodir=$TMP

"---------------------------------------------------------------------------
" ファイル名に大文字小文字の区別がないシステム用の設定:
"   (例: DOS/Windows/MacOS)
"
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  " tagsファイルの重複防止
  set tags=./tags,tags
endif

"---------------------------------------------------------------------------
" コンソールでのカラー表示のための設定(暫定的にUNIX専用)
if has('unix') && !has('gui_running')
  let uname = system('uname')
  if uname =~? "linux"
    set term=builtin_linux
  elseif uname =~? "freebsd"
    set term=builtin_cons25
  elseif uname =~? "Darwin"
    set term=beos-ansi
  else
    set term=builtin_xterm
  endif
  unlet uname
endif

"---------------------------------------------------------------------------
" コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応
if !has('gui_running') && has('xterm_clipboard')
  set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif

"---------------------------------------------------------------------------
" プラットホーム依存の特別な設定

" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

if has('mac')
  " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
  set iskeyword=@,48-57,_,128-167,224-235
endif

"---------------------------------------------------------------------------
" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | silent %!xxd -g 1
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | silent %!xxd -g 1
  au BufWritePost *.bin set nomod | endif
augroup END

"---------------------------------------------------------------------------
" 括弧とクォートを自動補完
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
vnoremap { "zdi^V{<C-R>z}<ESC>
vnoremap [ "zdi^V[<C-R>z]<ESC>
vnoremap ( "zdi^V(<C-R>z)<ESC>
vnoremap " "zdi^V"<C-R>z^V"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>

"---------------------------------------------------------------------------
"表示行単位で行移動する
nmap j gj
nmap k gk
vmap j gj
vmap k gk

"---------------------------------------------------------------------------
" 検索後、中央にフォーカスをあわせる
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

"---------------------------------------------------------------------------
" 文字コード設定
autocmd FileType cvs    :set fileencoding=euc-jp
autocmd FileType svn    :set fileencoding=utf-8
autocmd FileType ruby   :set fileencoding=utf-8
autocmd FileType eruby  :set fileencoding=utf-8
autocmd FileType python :set fileencoding=utf-8

"---------------------------------------------------------------------------
" コマンドラインでのキーバインドを Emacs スタイルにする
" Ctrl+Aで行頭へ移動
:cnoremap <C-A>		<Home>
" Ctrl+Bで一文字戻る
:cnoremap <C-B>		<Left>
" Ctrl+Dでカーソルの下の文字を削除
:cnoremap <C-D>		<Del>
" Ctrl+Eで行末へ移動
:cnoremap <C-E>		<End>
" Ctrl+Fで一文字進む
:cnoremap <C-F>		<Right>
" Ctrl+Nでコマンドライン履歴を一つ進む
:cnoremap <C-N>		<Down>
" Ctrl+Pでコマンドライン履歴を一つ戻る
:cnoremap <C-P>		<Up>
" Alt+Ctrl+Bで前の単語へ移動
:cnoremap <Esc><C-B>	<S-Left>
" Alt+Ctrl+Fで次の単語へ移動
:cnoremap <Esc><C-F>	<S-Right> 

"---------------------------------------------------------------------------
" マーク位置へのジャンプを行だけでなく桁位置も復元できるようにする
map ' `
" Ctrl+Nで次のバッファを表示
map <C-N>   :bnext<CR>
" Ctrl+Pで前のバッファを表示
map <C-P>   :bprevious<CR>
" 挿入モードでCtrl+kを押すとクリップボードの内容を貼り付けられるようにする
imap <C-K>  <ESC>"*pa
" Ctrl+Shift+Jで上に表示しているウィンドウをスクロールさせる
nnoremap <C-S-J> <C-W>k<C-E><C-W><C-W>

"---------------------------------------------------------------------------
" ファイルブラウザでバッファで開いているファイルのディレクトリを開く
:set browsedir=buffer

"---------------------------------------------------------------------------
" ファンクションキー設定
nmap <F2> ggVG
map  <F3> :Explore<CR>
nmap <F4> :close<CR>
nmap <F5> :ls<CR>
map  <F6> :bnext<CR>
map  <F7> :bprevious<CR>
map  <F8> <C-d>
map  <F9> <C-u>

"---------------------------------------------------------------------------

imap <C-Space> <C-X><C-O>

" scroll
set scrolloff=999

" fold
set foldmethod=marker
set fillchars=vert:I " :vsplit (i)

" history
set history=200

" match time
set matchtime=2

" status line
set statusline=
set statusline+=[*%n]\  " バッファ番号
set statusline+=%f\     " ファイル名
set statusline+=%{'['.(&fenc!=''?&fenc:'?').'-'.&ff.']'} " 文字コード
" set statusline+=%{'['.GetShortEncodingJP().'-'.&ff.']'} " 文字コード
set statusline+=%m      " バッファ状態[+]とか
set statusline+=%r      " 読み取り専用フラグ
set statusline+=%h      " ヘルプバッファ
set statusline+=%w      " プレビューウィンドウ
set statusline+=%=      " 区切り
set statusline+=\ %{strftime('%c')}  " 時間
set statusline+=%4l,%2c " 行、列
set statusline+=%3p%%   " どこにいるか
set statusline+=%<      " 折り返しの指定

set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" Copyright (C) 2007 RailsInstall / 2006 KaoriYa/MURAOKA Taro
" -----
"---------------------------
" Start Neobundle Settings.
"---------------------------
" 
" デフォルトのユーザーランタイムディレクトリを定義する
if $HOME == $USERPROFILE
  let defaultUserRuntimeDir='~/vimfiles'
else
  let defaultUserRuntimeDir='~/.vim'
  if &runtimepath !~ '\v(\~|home[/\\][^,/\\]+)[/\\]\.vim[/\\]*(,|$)'
    let &runtimepath = '~/.vim,' . &runtimepath . ',~/.vim/after'
  endif
endif

" bundleで管理するディレクトリを指定
let &runtimepath .= ',' . defaultUserRuntimeDir . '/bundle/neobundle.vim/'
  " Required:
call neobundle#begin(expand(defaultUserRuntimeDir . '/bundle/'))
 
" neobundle自体をneobundleで管理
NeoBundleFetch 'Shougo/neobundle.vim'
 
" 今後このあたりに追加のプラグインをどんどん書いて行きます！！"
if !has('kaoriya')
  NeoBundle 'Shougo/vimproc.vim',{
\ 'build' : {
\     'windows' : 'tools\\update-dll-mingw',
\     'cygwin' : 'make -f make_cygwin.mak',
\     'mac' : 'make -f make_mac.mak',
\     'linux' : 'make',
\     'unix' : 'gmake',
\    },
\ }
endif
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'honza/vim-snippets'
NeoBundle 'Shougo/neco-vim'
NeoBundle 'Shougo/neco-syntax'
"NeoBundle 'chase/vim-ansible-yaml'
NeoBundle 'hirsaeki-mki/vim-ansible-yaml'
NeoBundle 'hirsaeki-mki/eskk.vim'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'kana/vim-operator-user'
NeoBundle 'rhysd/vim-operator-surround'
NeoBundle 'hirsaeki-mki/Vim-Jinja2-Syntax'

NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'noahfrederick/vim-noctu'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'kannokanno/previm'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'Konfekt/FastFold'

call neobundle#end()
 
" Required:
filetype plugin indent on

"==========================================
"neocomplete.vim
"==========================================
if neobundle#tap('neocomplete.vim')
  call neobundle#config({
        \ 'depends': ['Shougo/context_filetype.vim', 'ujihisa/neco-look', 'Shougo/neco-syntax'],
        \})
  "use neocomplete.
  let g:neocomplete#enable_at_startup = 1
  " Use smartcase.
  let g:neocomplete#enable_smart_case = 1
  " Set minimun keyword length
  let g:neocomplete#min_keyword_length = 2
  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 3
  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
  " Define dictionary.
  let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default' : '',
        \ 'vimshell' : $HOME.'/.vimshell_hist',
        \ 'scheme' : $HOME.'/.gosh_completions'
        \ }
  " Define keyword.
  if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
  endif
  let g:neocomplete#keyword_patterns['default'] = '\h\w*'
  " Plugin key-mappings.
  inoremap <expr><C-g>  neocomplete#undo_completion()
  inoremap <expr><C-l>  neocomplete#complete_common_string()
  " 補完候補が表示されている場合は確定。そうでない場合は改行
  inoremap <expr><CR>  pumvisible() ? neocomplete#close_popup() : "<CR>"

  call neobundle#untap()
endif
"==========================================
"neosnippet.vim
"==========================================
let g:neosnippet#snippets_directory=defaultUserRuntimeDir . '/bundle/vim-snippets/snippets'
let g:neosnippet#snippets_directory.=',' . defaultUserRuntimeDir . '/bundle/vim-ansible-yaml/snippets'

"key-mapping
" <TAB>: completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)

" SuperTab like snippets behavior.
" imap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
imap <expr><TAB> pumvisible() ? "\<C-n>" : neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

"==========================================
"eskk
"==========================================
set imdisable
if has('win32')
  let g:eskk#large_dictionary = {
        \   'path': $APPDATA . '\skk\SKK-JISYO.L',
        \   'sorted': 0,
        \}
else
  let g:eskk#large_dictionary = {
        \   'sorted': 0,
        \}
endif
let g:eskk#server = {
      \ 'host': 'localhost',
      \ 'port': 1178,
      \ }
let g:eskk#egg_like_newline = 1
let g:eskk#enable_completion = 1
let g:azik = 1
let g:eskk#enable_completion = 1
let g:eskk#tab_select_completion = 1
"exec "source " . defaultUserRuntimeDir . "/eskk_azik.vim"

"===============================
" vim-operator-surround
"===============================
if neobundle#tap('vim-operator-surround') 
  call neobundle#config({
        \'depends': ['kana/vim-operator-user']
        \})
  map <silent>sa <Plug>(operator-surround-append)
  map <silent>sd <Plug>(operator-surround-delete)
  map <silent>sr <Plug>(operator-surround-replace)
  
  call neobundle#untap()
endif

"===============================
" Vim-Jinja2-Syntax
"===============================
"===============================
" openbrowser.vim
"===============================
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" 未インストールのプラグインがある場合、インストールするかどうかを尋ねてくれるようにする設定
" 毎回聞かれると邪魔な場合もあるので、この設定は任意です。
"
NeoBundleCheck
 
"-------------------------
" End Neobundle Settings.
"-------------------------

"-----------------------------------------------------------------------
"  Local Setting--start

set noautochdir
set fileformats=unix,dos
au BufRead,BufNewFile *.uws set filetype=uwsc
autocmd FileType uwsc :set dictionary=~\uwsc.dict
autocmd FileType text :set tw=0
"setlocal omnifunc=syntaxcomplete#Complete

let g:ansible_options = { 'ignore_blank_lines' : 1}
let g:jellybeans_termcolors=16
"colorscheme ap_dark8
"colorscheme jellybeans
"colorscheme solarized
if has('win32') && !has('gui_running')
  colorscheme ap_dark8
  hi Visual ctermfg=7 ctermbg=12
  hi LineNr ctermfg=9
  hi Pmenu  ctermfg=0 ctermbg=9
  hi Folded ctermfg=10
else
  let g:solarized_termcolors=16
  set background=dark
  silent! colorscheme solarized
  " 画面を黒地に白にする (次行の先頭の " を削除すれば有効になる)
  "colorscheme evening " (Windows用gvim使用時はgvimrcを編集すること)
  "colorscheme koehler " (Windows用gvim使用時はgvimrcを編集すること)
  "colorscheme desert " (Windows用gvim使用時はgvimrcを編集すること)
  "colorscheme solarized " (Windows用gvim使用時はgvimrcを編集すること)
endif

" Create directores if the directory not existing when the buffer is saved
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END
"jqによるJSON整形
command! -nargs=? Jq call s:Jq(<f-args>)
function! s:Jq(...)
    if 0 == a:0
        let l:arg = "."
    else
        let l:arg = a:1
    endif
    execute "%! jq \"" . l:arg . "\""
endfunction
"json2yaml呼出
command! -nargs=? J2y call s:J2y(<f-args>)
function! s:J2y(...)
    if 0 == a:0
        let l:arg = "."
    else
        let l:arg = a:1
    endif
    execute "%! python2.7 /usr/local/bin/json2yaml " . l:arg
endfunction
"genesysのオプション整形
command! -nargs=? Gop call s:Gop(<f-args>)
function! s:Gop(...)
    if 0 == a:0
        let l:arg = "."
    else
        let l:arg = a:1
    endif
    execute "%! python2.7 /usr/local/bin/optfmt " . l:arg
endfunction
"Previmのbugに対するworkaround
autocmd FileType markdown set shellslash
