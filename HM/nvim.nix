{ pkgs, config, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.neovim.enable = true;
  programs.neovim.package = pkgs.neovim-nightly;
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
    nvim-treesitter
    nvim-treesitter.withPlugins (_: tree-sitter.allGrammars)
  ];

  programs.neovim.extraConfig = ''
    set langmap=dg,ek,fe,gt,il,jy,kn,lu,nj,pr,rs,sd,tf,ui,yo,op,DG,EK,FE,GT,IL,JY,KN,LU,NJ,PR,RS,SD,TF,UI,YO,OP
    set autoindent
    set showmatch
    set mouse=a
    set spell
    " hybrid line numbers
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
  home.file.".config/nvim/coc-settings.json".text = ''
        {
          "languageserver": {
            "nix": {
              
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
  home.file.".config/nvim/after/queries/nix/injections.scm".text = ''
    (
        (app [
            ((identifier) @_func)
            (select (identifier) (attrpath (attr_identifier) @_func . ))
        ]) (indented_string) @bash
        (#match? @_func "(writeShellScript(Bin)?)")
    )
  '';
  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;
}
