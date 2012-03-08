
call pathogen#infect()
set nocompatible
syn on
colorscheme solarized
set background=dark
set sm
set cindent
set number
set hlsearch
set ignorecase
set autoindent
se t_Co=16 " for solarized colorscheme

set shiftwidth=4    "Number of spaces to use for each step of (auto)indent.
set expandtab       "No real tab (spaces)
set softtabstop=4  "Number of spaces that a <Tab> counts for while performing editing
match ErrorMsg /\%>80v.\+/ "highlights characters over 80v
"set textwidth=80    "in insertion mode, no more than 80 characters
match ErrorMsg /\s\+$/ " highlight trailing whitespace


" allow toggling between local and default mode
function TabToggle()
    if &expandtab
        set shiftwidth=8
        set softtabstop=0
        set noexpandtab
    else
       set shiftwidth=4
       set softtabstop=4
       set expandtab
endif
endfunction
nmap <F9> mz:execute TabToggle()<CR>'z


map <C-Right> :tabn<CR>
imap <C-Right> <C-O>:tabn<CR>

map <C-Left> :tabp<CR>
imap <C-Left> <C-O>:tabp<CR>


map <C-Up> :tabnew<CR>
imap <C-Up> <C-O>:tabnew<CR>

map <C-Down> :tabc<CR>
imap <C-Down> <C-O>:tabc<CR>·

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


" Transparent editing of gpg encrypted files.
augroup encrypted
au!

" First make sure nothing is written to ~/.viminfo while editing
" an encrypted file.
autocmd BufReadPre,FileReadPre *.gpg set viminfo=
" We don’t want a swap file, as it writes unencrypted data to disk
autocmd BufReadPre,FileReadPre *.gpg set noswapfile
" Switch to binary mode to read the encrypted file
autocmd BufReadPre,FileReadPre *.gpg set bin
autocmd BufReadPre,FileReadPre *.gpg let ch_save = &ch|set ch=2
autocmd BufReadPost,FileReadPost *.gpg '[,']!gpg --decrypt 2> /dev/null
" Switch to normal mode for editing
autocmd BufReadPost,FileReadPost *.gpg set nobin
autocmd BufReadPost,FileReadPost *.gpg let &ch = ch_save|unlet ch_save
autocmd BufReadPost,FileReadPost *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

" Convert all text to encrypted text before writing
autocmd BufWritePre,FileWritePre *.gpg '[,']!gpg --default-recipient-self -ae 2>/dev/null
" Undo the encryption so we are back in the normal text, directly
" after the file has been written.
autocmd BufWritePost,FileWritePost *.gpg u
augroup END

