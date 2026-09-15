syntax on
set termguicolors

" y/d/p (yank/delete/paste) use the macOS system clipboard instead of vim's
" own internal register - see README/chat for why Cmd-C/Cmd-X don't map
" cleanly onto a modal terminal editor.
set clipboard=unnamed

" Mouse-drag now enters visual mode and selects text, like a normal GUI
" editor, instead of only moving the cursor to where you release the click.
set mouse=a
