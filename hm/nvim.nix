{ pkgs, config, ... }:

let
  lua = text: ''
    lua << EOF
    ${text}
    EOF
  '';

  /* surround-nvim = pkgs.vimUtils.buildVimPlugin {
       name = "surround-nvim";
       src = pkgs.fetchFromGitHub {
         owner = "blackCauldron7";
         repo = "surround.nvim";
         rev = "43c85b5515c5ef597a0c527f68faa5b5908e9858";
         sha256 = "1lsmnfif31r6ipfa3sij99riw1s97mh9pzas4i9cqvf0q4vajc0s";
       };
     };
  */

  mark-radar = pkgs.vimUtils.buildVimPlugin {
    name = "mark-radar";
    src = pkgs.fetchFromGitHub {
      owner = "winston0410";
      repo = "mark-radar.nvim";
      rev = "a557094f6b85cf9870a545680f9b8bd50970aa94";
      sha256 = "11cqxlhb4287dl9azfa0m5jy1bfl09yy3dp2057k3ilzph6w6zaw";
    };
  };

  gesture = pkgs.vimUtils.buildVimPlugin {
    name = "gesture";
    src = pkgs.fetchFromGitHub {
      owner = "legendofmiracles";
      repo = "gesture.nvim";
      rev = "abf01c2fb64c4b90f64b66f2764a2ff64b2a22e7";
      sha256 = "19bzhm5qrbg2fl2wibambaf9c0myxapqv3zvqskgi3c28z80ylmv";
    };
  };

  kommentary = pkgs.vimUtils.buildVimPlugin rec {
    name = "kommentary";
    src = pkgs.fetchFromGitHub {
      owner = "b3nj5m1n";
      repo = name;
      rev = "f0b6d75df0a263fc849b0860dc8a27f4bed743db";
      sha256 = "0z6rcvlgp00hrgjff31vwssrq000pwwak5kw6k1xz2349n01chsa";
    };
  };

  luadev = pkgs.vimUtils.buildVimPlugin {
    name = "luadev";
    src = pkgs.fetchFromGitHub {
      owner = "bfredl";
      repo = "nvim-luadev";
      rev = "a5f8bc0793acf0005183647f95498fb8a429d703";
      sha256 = "1a71cg34radsm4aphr7yir1mq7blp8ya80i7chamwm1v3l06xcla";
    };
  };

  venn = pkgs.vimUtils.buildVimPlugin {
    name = "venn";
    src = pkgs.fetchFromGitHub {
      owner = "jbyuki";
      repo = "venn.nvim";
      rev = "425c9df332b46d8b13bc4e641646a9fb3db9c0c8";
      sha256 = "0hf8v4c7y55b54na6yyq32d5192fsx9kq7scpp81b6hhi4rqxa88";
    };
  };

  #package = pkgs.neovim-nightly;
  #package = pkgs.neovim;

in with import ./colors.nix { }; {
  home.sessionVariables = { EDITOR = "nvim"; };

  programs.neovim = {
    enable = true;
    #package = package;
    withNodeJs = true;
    plugins = with pkgs.vimPlugins; [
      undotree
      # luadev
      coc-nvim
      {
        plugin = kommentary;
        config = lua ''
          vim.g.kommentary_create_default_mappings = false
        '';
      }
      coc-rust-analyzer
      # vimspector
      vim-nix
      vim-highlightedyank
      auto-pairs
      venn
      # lush-nvim
      {
        plugin = pkgs.vimPlugins.nvim-base16;
        config = lua ''
            -- equilibrium-dark
            require('base16-colorscheme').setup({
              base00 = '#16161D', base01 = '#2c313c', base02 = '#3e4451', base03 = '#6c7891',
              base04 = '#565c64', base05 = '#abb2bf', base06 = '#9a9bb3', base07 = '#c5c8e6',
              base08 = '#e06c75', base09 = '#d19a66', base0A = '#e5c07b', base0B = '#98c379',
              base0C = '#56b6c2', base0D = '#0184bc', base0E = '#c678dd', base0F = '#a06949',
          })
        '';
      }
      # vim-processing
      {
        plugin = pkgs.vimPlugins.vim-gitgutter;
        config = ''
          highlight clear SignColumn
          let g:gitgutter_set_sign_backgrounds = 1
        '';
      }
      /* {
           plugin = pkgs.vimPlugins.vim-airline;
           config = ''
             let g:airline_powerline_fonts = 1
           '';
         }
      */
      {
        plugin = vim-sneak;
        config = ''
          let g:sneak#label = 1
          map f <Plug>Sneak_s
          map F <Plug>Sneak_S
        '';
      }
      vim-fugitive
      registers-nvim
      fzf-vim
      colorizer
      {
        plugin = vim-surround;
        config = ''
          " Surround custom mapping for Colemak
          let g:surround_no_mappings = 1
          if !exists("g:surround_no_insert_mappings") || ! g:surround_no_insert_mappings
              if !hasmapto("<Plug>Isurround","i") && "" == mapcheck("<C-S>","i")
                  imap    <C-S> <Plug>Isurround
              endif
              imap      <C-G>s <Plug>Isurround
              imap      <C-G>S <Plug>ISurround
          endif
        '';
      }
      /* {
           plugin = surround-nvim;
           config = ''
             let g:surround_mappings_style = "surround"
           '';
         }
      */
      {
        plugin = coc-snippets;
        config = ''
          inoremap <silent><expr> <TAB>
          \ pumvisible() ? coc#_select_confirm() :
          \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',\'\'])\<CR>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()

          function! s:check_back_space() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~# '\s'
          endfunction

          let g:coc_snippet_next = '<tab>'
        '';
      }
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

          let g:which_key_map.s = {
                      \ 'name':"Surrounding",
                      \ 'd' : [ '<Plug>Dsurround'                  , 'delete surrounding'   ],
                      \ 'c' : [ '<Plug>Csurround'                  , 'change surrounding'   ],
                      \ 'a' : [ '<Plug>Ysurround'                  , 'add surrounding'      ],
                      \ 'o' : [ '<Plug>Yssurround'                 , 'surround entire line' ],
                      \ 'O' : [ '<Plug>YSsurround','surround entire line but its on other' ],
                      \ 'v' : [ '<Plug>VSurround'                  , 'visual surround'      ],
                      \}

          au VimEnter * call which_key#register('<Space>', "g:which_key_map")

          nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
          nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
        '';
      }
      {
        # use ` to view all marks
        plugin = mark-radar;
        config = lua ''require("mark-radar").setup()'';
      }
      {
        plugin = gesture;
        config = ''
          nnoremap <RightMouse> <Nop>
          nnoremap <silent> <RightDrag> <Cmd>lua require("gesture").draw()<CR>
          nnoremap <silent> <RightRelease> <Cmd>lua require("gesture").finish()<CR>
          ${lua ''
            local gesture = require('gesture')
            gesture.register({
              name = "uncomment",
              inputs = { gesture.down() },
              action = "normal! <Plug>kommentary_line_default"
            })
            gesture.register({
              name = "next buffer",
              inputs = { gesture.right() },
              action = "bn"
            })
            gesture.register({
              name = "previous buffer",
              inputs = { gesture.left() },
              action = function() -- also can use function
                vim.cmd("bp")
              end,
            })
            gesture.register({
              name = "go back",
              inputs = { gesture.right(), gesture.left() },
              -- map to `<C-o>` keycode
              action = [[lua vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>", true, false, true), "n", true)]]
            })
          ''}
        '';
      }
      vim-bufferline
      coc-pyright
      /* {
         plugin = nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars);
         config = ''
         set foldlevel=99
         set foldmethod=expr
         set foldexpr=nvim_treesitter#foldexpr()
         '' + lua ''
         require'nvim-treesitter.configs'.setup {
         highlight = {
         enable = true,
         },
         indent = {
         enable = true,
         },
         query_linter = {
         enable = true,
         },
         }
         '';
         }
         {
         plugin = playground;
         config = lua ''
         require "nvim-treesitter.configs".setup {
         playground = {
         enable = true,
         disable = {},
         updatetime = 25,
         keymaps = {
         open = "gt",
         },
         }
         }
         '';
         }

         {
         plugin = nvim-ts-rainbow;
         config = lua ''
         require'nvim-treesitter.configs'.setup {
         rainbow = {
         enable = true,
         extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
         max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
         }
         }
         '';
         }
      */
    ];
    extraConfig = ''
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
      " syntax off
      set updatetime=100
      let g:languagetool_server_command="languagetool-http-server"
      " When editing a file, always jump to the last cursor position
      autocmd BufReadPost *
      \ if line("'\"") > 0 && line ("'\"") <= line("$") |
      \   exe "normal g'\"" |
      \ endif
      set expandtab
      set tabstop=4
      " inoremap ne <Esc>
      set timeoutlen=100
      "if (has("termguicolors"))
      "  set termguicolors
      "endif

      " create missing dirs
      autocmd BufWritePre,FileWritePre * silent! call mkdir(expand('<afile>:p:h'), 'p')

      " backspace in normal mode for switching back to last used buffer
      nnoremap <BS> <C-^>

      " Display 5 lines above/below the cursor when scrolling
      set scrolloff=5
      " Fixes common backspace problems
      set backspace=indent,eol,start

      " ctrl + backspace
      imap <C-BS> <C-W>

      " color of lines and line
      " highlight LineNr guifg=${pink}
      " highlight CursorLine guifg=${pink}

      " Speed up scrolling in Vim
      set ttyfast

      " Highlight matching pairs of brackets. Use the '%' character to jump between them.
      set matchpairs+=<:>

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


      " statusline
      set ls=0
      ${lua ''
         local mode_map = {
            ['n'] = 'normal ',
            ['no'] = 'n·operator pending ',
            ['v'] = 'visual ',
            ['V'] = 'v·line ',
            [''] = 'v·block ',
            ['s'] = 'select ',
            ['S'] = 's·line ',
            [''] = 's·block ',
            ['i'] = 'insert ',
            ['R'] = 'replace ',
            ['Rv'] = 'v·replace ',
            ['c'] = 'command ',
            ['cv'] = 'vim ex ',
            ['ce'] = 'ex ',
            ['r'] = 'prompt ',
            ['rm'] = 'more ',
            ['r?'] = 'confirm ',
            ['!'] = 'shell ',
            ['t'] = 'terminal '
        }

        local function mode()
            local m = vim.api.nvim_get_mode().mode
            if mode_map[m] == nil then return m end
            return mode_map[m]
        end

        vim.api.nvim_exec(
          [[
            hi PrimaryBlock   ctermfg=06 ctermbg=00
            hi SecondaryBlock ctermfg=08 ctermbg=00
            hi Blanks   ctermfg=07 ctermbg=00
          ]], false)

        local stl = {
          '%#PrimaryBlock#',
          mode(),
          '%#SecondaryBlock#',
          '%#Blanks#',
          '%f',
          '%m',
          '%=',
          '%#SecondaryBlock#',
          '%l,%c ',
          '%#PrimaryBlock#',
          '%{&filetype}',
        }

        -- vim.o.statusline = table.concat(stl)
      ''}
    '';
  };

  home.file.".config/nvim/coc-settings.json".text = ''
      {
        "languageserver": {
          "nix": {
            "command": "rnix-lsp",
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
  home.file = {
    ".config/nvim/after/queries/nix/injections.scm".text = ''
      (
          (app [
              ((identifier) @_func)
              (select (identifier) (attrpath (attr_identifier) @_func . ))
          ]) (indented_string) @bash
          (#match? @_func "(writeShellScript(Bin)?)")
          ; #!/bin/sh shebang highlighting
          ((indented_string) @bash @_code
            (#lua-match? @_code "\s*#!\s*/bin/sh"))
          ; Bash strings
          ((indented_string) @bash @_code
            (#lua-match? @_code "\s*## Syntax: bash"))
          ; Lua strings
          ((indented_string) @lua @_code
            (#lua-match? @_code "\s*\\-\- Syntax: lua"))
      )
    '';
  };

  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;
}