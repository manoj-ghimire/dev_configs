"Mostly stolen from Yan Pritzer's most excellent Yadr (github.com/skwp/dotfiles)

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible


if empty(glob('~/.config/nvim/autoload/plug.vim'))
      silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs\
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif


" ================ General Config ====================
"
"
set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"turn on syntax highlighting
syntax on

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

" ================ Indentation ======================

"set autoindent
"set smartindent
"set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>p


call plug#begin('~/.config/nvim/plugged')

  " Cool plugins

  "DevIcons
  Plug 'ryanoasis/vim-devicons'

  " NERDTree
  Plug 'preservim/nerdtree'

  " Fuzzy Finder
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all'  }

  " Syntactic language support
  Plug 'cespare/vim-toml'
  Plug 'stephpy/vim-yaml'
  Plug 'rhysd/vim-clang-format'
  Plug 'godlygeek/tabular'
  Plug 'plasticboy/vim-markdown'

  "GUI enhancements
  Plug 'itchyny/lightline.vim'
  Plug 'andymass/vim-matchup'

  " Autopair matching
  Plug 'cohama/lexima.vim'

  "Plug 'Shougo/neocomplete.vim'
  "Plug 'tommcdo/vim-exchange'
  "Plug 'ntpeters/vim-better-whitespace'
  "Plug 'tpope/vim-surround'
  "Plug 'tpope/vim-repeat'
  "Plug 'jiangmiao/auto-pairs'
  "Plug 'vim-scripts/CursorLineCurrentWindow'
  "Plug 'victormours/better-writing.vim'
  "Plug 'janko-m/vim-test'
  "Plug 'skywind3000/asyncrun.vim'
  "Plug 'dense-analysis/ale'
 
  " ##### Rust plugins ###########
 
  " Collection of common configurations for the     Nvim LSP client
  Plug 'neovim/nvim-lspconfig'
  " Completion framework
  Plug 'hrsh7th/nvim-cmp'
  " LSP completion source for nvim-cmp
  Plug 'hrsh7th/cmp-nvim-lsp'
  " Snippet completion source for nvim-cmp
  Plug 'hrsh7th/cmp-vsnip'
  " Other usefull completion sources
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-buffer'
  " See hrsh7th's other plugins for more complet    ion sources!
  " To enable more of the features of rust-analy    zer, such as inlay hints and more!
  Plug 'simrat39/rust-tools.nvim'
  " Snippet engine
  Plug 'hrsh7th/vim-vsnip'
  " Formating rust
  Plug 'rust-lang/rust.vim'
  
  " ### Rust Plugins End ####

  " Search
  "Plug 'henrik/vim-indexed-search'
  "Plug 'nixprime/cpsm'
  "Plug 'mileszs/ack.vim'
  
  " Git
  Plug 'tpope/vim-fugitive'
  
  " Visuals
  Plug 'dracula/vim'
  
  " Commenting
  "Plug 'tomtom/tlib_vim'
  "Plug 'tomtom/tcomment_vim'
  
  " HTML
  "Plug 'mattn/emmet-vim'
  "Plug 'slim-template/vim-slim'
  "Plug 'mustache/vim-mustache-handlebars'
  
  " Javascript
  "Plug 'pangloss/vim-javascript'
  "Plug 'mxw/vim-jsx'
  "Plug 'othree/yajs.vim'
  "Plug 'othree/javascript-libraries-syntax.vim'
  "Plug 'claco/jasmine.vim'
  "Plug 'kchmck/vim-coffee-script'
  "Plug 'lfilho/cosco.vim'
  
  " Terraform
  "Plug 'hashivim/vim-terraform'

call plug#end()

syntax enable


"=====================================================
"============   Rust Settings  =======================
"=====================================================

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF
local nvim_lsp = require'lspconfig'

local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
					-- Only show inlay hints for the current line
            only_current_line = false,
						-- wheter to show parameter hints with the inlay hints or not
            show_parameter_hints = true,
						-- prefix for parameter hints
            parameter_hints_prefix = "<- ",
						-- prefix for all the other hints (type, chaining)
            other_hints_prefix = "=> ",
						-- The color of the hints
            highlight = "Comment",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
    server = {
      -- on_attach is a callback called when the language server attachs to the buffer
      -- on_attach = on_attach,
      settings = {
        -- to enable rust-analyzer settings visit:
        -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
        ["rust-analyzer"] = {
          assist = {
            importMergeBehavior = "last",
            importPrefix = "by_self",
            },
          diagnostics = {
            disabled = { "unresolved-import" }
            },
          cargo = {
            loadOutDirsFromCheck = true
            },
          procMacro = {
          enable = true
          },                
        -- enable clippy on save
        checkOnSave = {
          command = "clippy"
          },
        }
      }
    },
}

require('rust-tools').setup(opts)
-- set inlay hints
require('rust-tools.inlay_hints').set_inlay_hints()
EOF

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})
EOF

" Code navigation shortcuts
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>


autocmd InsertLeave *.rs lua vim.lsp.buf.formatting_sync(nil, 200)
" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>

" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes


" FZF key bindings
nnoremap <C-f> :FZF<CR>
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-i': 'split',
  \ 'ctrl-v': 'vsplit' }


" NERD Tree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" Toggle
nnoremap <silent> <C-b> :NERDTreeToggle<CR>
map <silent> <C-n> :NERDTreeFocus<CR>


" Move line up or down
nnoremap <S-Up> :m-2<CR>
nnoremap <S-Down> :m+<CR>
inoremap <S-Up> <Esc>:m-2<CR>
inoremap <S-Down> <Esc>:m+<CR>


" Better search
set hlsearch
set incsearch

" grep word under cursor
nnoremap <Leader>g :grep! "\b<C-R><C-W>\b"<CR>:cw<CR><CR>

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" Move normally between wrapped lines
nmap j gj
nmap k gk
vmap j gj
vmap k gk

autocmd BufReadPre,FileReadPre *.md :set wrap

autocmd FocusLost * silent! wa " Automatically save file

set scrolloff=5 " Keep 5 lines below and above the cursor

set cursorline

set mouse=a " Enable mouse usage (all modes) in terminals
set shortmess+=c " don't give |ins-completion-menu| messages    

set laststatus=2
set relativenumber " Relative line numbers
set number " Also show current absolute line
set diffopt+=iwhite " No whitespace in vimdiff


set background=dark
" Current color scheme
colorscheme dracula
