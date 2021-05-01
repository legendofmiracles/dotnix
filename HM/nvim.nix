{ pkgs, config, ... }:

{
  programs.neovim.enable = true;
  programs.neovim.withNodeJs = true;
  programs.neovim.plugins = with pkgs.vimPlugins; [
    undotree
    coc-nvim
    coc-rust-analyzer
    vimspector
    vim-nix
    auto-pairs
    # vim-processing
    {
      plugin = gitgutter;
      config = ''
        highlight clear SignColumn
        let g:gitgutter_set_sign_backgrounds = 1
      '';
    }
    {
      plugin = airline;
      config = ''
        let g:airline_powerline_fonts = 1
      '';
    }
    fugitive
    fzf-vim
    colorizer
    surround
    {
      plugin = vim-which-key;
      config = ''
        let g:mapleader = "\<Space>"
        let g:maplocaleader = ','

        let g:which_key_map = {}

        let g:which_key_map.n = {
                    \ 'name':"code-actions",
                    \ 'g' : [ '<Plug>(coc-definition)'    , 'go to definition' ],
                    \ 'r' : [ '<Plug>(coc-references)'    , 'go to references' ],
                    \ 'n' : [ '<Plug>(coc-rename)'        , 'rename'           ],
                    \ 'd' : [ ':call Show_documentation()', 'show docs'        ],
                    \ 'f' : [ '<Plug>(coc-refactor)'      , 'refactor'         ],
                    \}

        let g:which_key_map.f = {
                    \ 'name':"FZF",
                    \ 'f' : [ ':Files'                , 'view files'       ],
                    \ 'c' : [ ':Commands'             , 'view commands'    ],
                    \ 'g' : [ ':Commits'              , 'view commits'     ],
                    \}

        let g:which_key_map.c = {
                    \ 'name':"Commenting",
                    \ 'c' : [ ':vnoremap cm :s!^!//! <CR>' , 'comment with //' ],
                    \}

        au VimEnter * call which_key#register('<Space>', "g:which_key_map")

        nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
        nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
      '';
    }
    vim-bufferline
    coc-pyright
    polyglot
  ];

  programs.neovim.extraConfig = ''
     set langmap=dg,ek,fe,gt,il,jy,kn,lu,nj,pr,rs,sd,tf,ui,yo,op,DG,EK,FE,GT,IL,JY,KN,LU,NJ,PR,RS,SD,TF,UI,YO,OP
"noremap d g
"noremap e k
"noremap f e
"noremap g t
"noremap i l
"noremap j y
"noremap k n
"noremap l u
"noremap n j
"noremap o p
"noremap p r
"noremap r s
"noremap s d
"noremap t f
"noremap u i
"noremap y o
"noremap D G
"noremap E K
"noremap F E
"noremap G T
"noremap I L
"noremap J Y
"noremap K N
"noremap L U
"noremap N J
"noremap O P
"noremap P R
"noremap R S
"noremap S D.
"noremap T F
"noremap U I
"noremap Y O
    set autoindent
    set showmatch
    set mouse=a
    set spell
    set nu rnu
    " new line without insert mode with enter, because when i copy a entire line with yy/dd it strips away the line ending
    nnoremap <Return> o<Esc>
    syntax on
    syntax enable
    set updatetime=100
    let g:languagetool_server_command="languagetool-http-server"
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal g'\"" |
    \ endif
    set expandtab
    set tabstop=4
    set timeoutlen=10
    if (has("termguicolors"))
      set termguicolors
    endif
    " color of lines and line
    highlight LineNr guifg=#FF217C
    " highlight CursorLine guifg=#FF217C

    " this shows trailing whitespaces
    highlight ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+$/

    " when copying/cutting strip it from newlines
    autocmd TextYankPost * let @@ = trim(@@)
    " Put plugins and dictionaries in this dir (also on Windows)
    " persistent undo
    let vimDir = '$HOME/.vim'

    if stridx(&runtimepath, expand(vimDir)) == -1
      " vimDir is not on runtimepath, add it
      let &runtimepath.=','.vimDir
    endif

    " Keep undo history across sessions by storing it in a file
    if has('persistent_undo')
        let myUndoDir = expand(vimDir . '/undodir')
        " Create dirs
        call system('mkdir ' . vimDir)
        call system('mkdir ' . myUndoDir)
        let &undodir = myUndoDir
        set undofile
    endif
  '';
  home.file.coc-settings = {
    text = ''
      {
        "languageserver": {
          "nix": {
            "command": "rnix",
            "filetypes": [
              "nix"
            ]
         }
        },
        "languageserver": {
          "haskell": {
            "command": "haskell-language-server-wrapper",
            "args": ["--lsp"],
            "rootPatterns": ["*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml"],
            "filetypes": ["haskell", "lhaskell"]
        }
      }
    }
    '';
    target = ".config/nvim/coc-settings.json";
  };
  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;
}
