{ pkgs, config, ... }:

let
  lua = text: ''
    lua << EOF
    ${text}
    EOF
  '';

 mark-radar = pkgs.vimUtils.buildVimPlugin {
    name = "mark-radar";
    src = pkgs.fetchFromGitHub {
      owner = "winston0410";
      repo = "mark-radar.nvim";
      rev = "d7fb84a670795a5b36b18a5b59afd1d3865cbec7";
      sha256 = "1y3l2c7h8czhw0b5m25iyjdyy0p4nqk4a3bxv583m72hn4ac8rz9";
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
      /*{
        plugin = pkgs.vimPlugins.nvim-base16;
        config = lua ''
            -- equilibrium-dark
            require('base16-colorscheme').setup({
              base00 = '#faf4ed', base01 = '#fffaf3', base02 = '#f2e9de', base03 = '#9893a5',
              base04 = '#6e6a86', base05 = '#575279', base06 = '#555169', base07 = '#26233a',
              base08 = '#1f1d2e', base09 = '#b4637a', base0A = '#ea9d34', base0B = '#d7827e',
              base0C = '#286983', base0D = '#56949f', base0E = '#907aa9', base0F = '#c5c3ce',
          })
        '';
      }*/
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
      #fzf-vim
      telescope-nvim
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
                      \ 'a' : [ '<Plug>(coc-references)'    , 'go to references' ],
                      \ 'n' : [ '<Plug>(coc-rename)'        , 'rename'           ],
                      \ 'd' : [ ':call Show_documentation()', 'show docs'        ],
                      \ 'f' : [ '<Plug>(coc-refactor)'      , 'refactor'         ],
                      \}

          let g:which_key_map.f = {
                      \ 'name':"FZF",
                      \ 'a' : [ ':Telescope file_browser' , 'view files'   ],
                      \ 'f' : [ ':Telescope find_files'   , 'view files'   ],
                      \ 'g' : [ ':Telescope git_commits'  , 'view commits' ],
                      \ 'l' : [ ':Telescope live_grep'    , 'live grep'    ],
                      \}

          let g:which_key_map.s = {
                      \ 'name':"Surrounding",
                      \ 'd' : [ '<Plug>Dsurround'                  , 'delete surrounding'   ],
                      \ 'c' : [ '<Plug>Csurround'                  , 'change surrounding'   ],
                      \ 'a' : [ '<Plug>Ysurround'                  , 'add surrounding'      ],
                      \ 'o' : [ '<Plug>Yssurround'                 , 'surround entire line' ],
                      \ 'O' : [ '<Plug>YSsurround', 'surround entire line but its on other' ],
                      \ 'v' : [ '<Plug>VSurround'                  , 'visual surround'      ],
                      \}

          au VimEnter * call which_key#register('<Space>', "g:which_key_map")

          nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
          vnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
          nnoremap <silent> <localleader> :<c-u>WhichKey  ','<CR>
          '';
          /*config = lua ''
            require("which-key").setup {

            }
          '';*/
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
      if (has("termguicolors"))
        set termguicolors
      endif

      " create missing dirs
      autocmd BufWritePre,FileWritePre * silent! call mkdir(expand('<afile>:p:h'), 'p')

      " backspace in normal mode for switching back to last used buffer
      nnoremap <BS> <C-^>

      " Display 5 lines above/below the cursor when scrolling
      set scrolloff=5
      " Fixes common backspace problems
      set backspace=indent,eol,start

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

      " colorscheme
      " File generated by L3af's Nix config
      " modify in config/theme.nix

      if version > 580
        hi clear
        if exists("syntax_on")
          syntax reset
        endif
      endif

      '';
      /*let g:colors_name = "nix"

      if has('nvim')
        let g:terminal_color_0 = "#232136"
        let g:terminal_color_1 = "#B4637A"
        let g:terminal_color_2 = "#569F84"
        let g:terminal_color_3 = "#EA9D34"
        let g:terminal_color_4 = "#286983"
        let g:terminal_color_5 = "#907AA9"
        let g:terminal_color_6 = "#56959F"
        let g:terminal_color_7 = "#F2E9DE"
        let g:terminal_color_8 = "#575279"
        let g:terminal_color_9 = "#D7827E"
        let g:terminal_color_10 = "#9CD8C3"
        let g:terminal_color_11 = "#F6C177"
        let g:terminal_color_12 = "#CECAED"
        let g:terminal_color_13 = "#C4A7E7"
        let g:terminal_color_14 = "#9CCFD8"
        let g:terminal_color_15 = "#FAF4ED"
      endif

      if has('terminal')
        let g:terminal_ansi_colors = [ "#232136", "#B4637A", "#569F84", "#EA9D34", "#286983", "#907AA9", "#56959F", "#F2E9DE", "#575279", "#D7827E", "#9CD8C3", "#F6C177", "#CECAED", "#C4A7E7", "#9CCFD8", "#FAF4ED" ]
      endif

      hi Bold guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=BOLD cterm=BOLD
      hi Boolean guifg=#D7827E guibg=NONE ctermfg=9 ctermbg=NONE gui=NONE cterm=NONE
      hi Character guifg=#EA9D34 guibg=NONE ctermfg=3 ctermbg=NONE gui=NONE cterm=NONE
      hi ColorColumn guifg=NONE guibg=#575279 ctermfg=NONE ctermbg=8 gui=NONE cterm=NONE
      hi Comment guifg=#9893a5 guibg=NONE ctermfg=3 ctermbg=NONE gui=NONE cterm=NONE
      hi Conceal guifg=#C4A7E7 guibg=#F5E9DA ctermfg=13 ctermbg=0 gui=NONE cterm=NONE
      hi Conditional guifg=#56959F guibg=NONE ctermfg=6 ctermbg=NONE gui=NONE cterm=NONE
      hi Constant guifg=#D7827E guibg=NONE ctermfg=9 ctermbg=NONE gui=NONE cterm=NONE
      hi Cursor guifg=#F5E9DA guibg=#F5E9DA ctermfg=0 ctermbg=7 gui=NONE cterm=NONE
      hi CursorLine guifg=NONE guibg=#EDD7BD ctermfg=NONE ctermbg=8 gui=NONE cterm=NONE
      hi CursorLineNr guifg=#575279 guibg=#EDD7BD ctermfg=7 ctermbg=8 gui=NONE cterm=NONE
      hi Debug guifg=#575279 guibg=NONE ctermfg=8 ctermbg=NONE gui=NONE cterm=NONE
      hi Define guifg=#9CCFD8 guibg=NONE ctermfg=14 ctermbg=NONE gui=NONE cterm=NONE
      hi Delimiter guifg=#9893a5 guibg=NONE ctermfg=15 ctermbg=NONE gui=NONE cterm=NONE
      hi DiffAdd guifg=#9893a5 guibg=NONE ctermfg=15 ctermbg=NONE gui=NONE cterm=NONE
      hi DiffChange guifg=#EA9D34 guibg=NONE ctermfg=3 ctermbg=NONE gui=NONE cterm=NONE
      hi DiffDelete guifg=#D7827E guibg=NONE ctermfg=9 ctermbg=NONE gui=NONE cterm=NONE
      hi Directory guifg=#907AA9 guibg=NONE ctermfg=5 ctermbg=NONE gui=NONE cterm=NONE
      hi Error guifg=#B4637A guibg=NONE ctermfg=1 ctermbg=NONE gui=NONE cterm=NONE
      hi ErrorMsg guifg=#B4637A guibg=NONE ctermfg=1 ctermbg=NONE gui=NONE cterm=NONE
      hi Exception guifg=#907AA9 guibg=NONE ctermfg=5 ctermbg=NONE gui=NONE cterm=NONE
      hi Float guifg=#D7827E guibg=NONE ctermfg=9 ctermbg=NONE gui=NONE cterm=NONE
      hi FoldColumn guifg=#575279 guibg=#EDD7BD ctermfg=7 ctermbg=8 gui=NONE cterm=NONE
      hi Folded guifg=#575279 guibg=#EDD7BD ctermfg=7 ctermbg=8 gui=NONE cterm=NONE
      hi Function guifg=#575279 guibg=NONE ctermfg=7 ctermbg=NONE gui=NONE cterm=NONE
      hi Identifier guifg=#907AA9 guibg=NONE ctermfg=5 ctermbg=NONE gui=NONE cterm=NONE
      hi IncSearch guifg=NONE guibg=#EDD7BD ctermfg=NONE ctermbg=8 gui=NONE cterm=NONE
      hi Include guifg=#56959F guibg=NONE ctermfg=6 ctermbg=NONE gui=NONE cterm=NONE
      hi Integer guifg=#D7827E guibg=NONE ctermfg=9 ctermbg=NONE gui=NONE cterm=NONE
      hi LineNr guifg=#9893a5 guibg=NONE ctermfg=15 ctermbg=NONE gui=NONE cterm=NONE
      hi Macro guifg=#575279 guibg=NONE ctermfg=7 ctermbg=NONE gui=NONE cterm=NONE
      hi MatchParen guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=BOLD cterm=BOLD
      hi ModeMsg guifg=#F6C177 guibg=NONE ctermfg=11 ctermbg=NONE gui=NONE cterm=NONE
      hi MoreMsg guifg=#F6C177 guibg=NONE ctermfg=11 ctermbg=NONE gui=NONE cterm=NONE
      hi Noise guifg=#9893a5 guibg=NONE ctermfg=15 ctermbg=NONE gui=NONE cterm=NONE
      hi NonText guifg=#EA9D34 guibg=NONE ctermfg=3 ctermbg=NONE gui=NONE cterm=NONE
      hi Normal guifg=#575279 guibg=#F5E9DA ctermfg=7 ctermbg=0 gui=NONE cterm=NONE
      hi Number guifg=#D7827E guibg=NONE ctermfg=9 ctermbg=NONE gui=NONE cterm=NONE
      hi Operator guifg=#907AA9 guibg=NONE ctermfg=5 ctermbg=NONE gui=NONE cterm=NONE
      hi Pmenu guifg=#575279 guibg=#EDD7BD ctermfg=7 ctermbg=8 gui=NONE cterm=NONE
      hi PmenuSbar guifg=NONE guibg=#EDD7BD ctermfg=NONE ctermbg=7 gui=NONE cterm=NONE
      hi PmenuSel guifg=#EDD7BD guibg=#907AA9 ctermfg=0 ctermbg=7 gui=BOLD cterm=BOLD
      hi PmenuThumb guifg=NONE guibg=#907AA9 ctermfg=NONE ctermbg=8 gui=NONE cterm=NONE
      hi PreProc guifg=#907AA9 guibg=NONE ctermfg=5 ctermbg=NONE gui=NONE cterm=NONE
      hi Question guifg=#907AA9 guibg=NONE ctermfg=5 ctermbg=NONE gui=NONE cterm=NONE
      hi QuickFixLine guifg=NONE guibg=#B4637A ctermfg=NONE ctermbg=1 gui=NONE cterm=NONE
      hi Quote guifg=#F6C177 guibg=NONE ctermfg=11 ctermbg=NONE gui=NONE cterm=NONE
      hi Repeat guifg=#9CD8C3 guibg=NONE ctermfg=10 ctermbg=NONE gui=NONE cterm=NONE
      hi Search guifg=NONE guibg=#EDD7BD ctermfg=NONE ctermbg=8 gui=BOLD cterm=BOLD
      hi SignColumn guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=NONE cterm=NONE
      hi Special guifg=#286983 guibg=NONE ctermfg=4 ctermbg=NONE gui=NONE cterm=NONE
      hi SpecialChar guifg=#D7827E guibg=NONE ctermfg=9 ctermbg=NONE gui=NONE cterm=NONE
      hi SpecialKey guifg=#D7827E guibg=NONE ctermfg=9 ctermbg=NONE gui=NONE cterm=NONE
      hi Statement guifg=#907AA9 guibg=NONE ctermfg=5 ctermbg=NONE gui=NONE cterm=NONE
      hi StatusLine guifg=#575279 guibg=#EDD7BD ctermfg=7 ctermbg=0 gui=NONE cterm=NONE
      hi StatusLineNC guifg=#575279 guibg=#EDD7BD ctermfg=7 ctermbg=0 gui=NONE cterm=NONE
      hi StorageClass guifg=#9CD8C3 guibg=NONE ctermfg=10 ctermbg=NONE gui=NONE cterm=NONE
      hi String guifg=#EA9D34 guibg=NONE ctermfg=3 ctermbg=NONE gui=NONE cterm=NONE
      hi Structure guifg=#907AA9 guibg=NONE ctermfg=5 ctermbg=NONE gui=NONE cterm=NONE
      hi Substitute guifg=NONE guibg=#F5E9DA ctermfg=NONE ctermbg=7 gui=BOLD cterm=BOLD
      hi TSFunction guifg=#907AA9 guibg=NONE ctermfg=5 ctermbg=NONE gui=NONE cterm=NONE
      hi TSKeywordFunc guifg=#907AA9 guibg=NONE ctermfg=5 ctermbg=NONE gui=NONE cterm=NONE
      hi TSMethod guifg=#907AA9 guibg=NONE ctermfg=5 ctermbg=NONE gui=NONE cterm=NONE
      hi TSProperty guifg=#EA9D34 guibg=NONE ctermfg=3 ctermbg=NONE gui=NONE cterm=NONE
      hi TSPunctBracket guifg=#9893a5 guibg=NONE ctermfg=15 ctermbg=NONE gui=NONE cterm=NONE
      hi TSType guifg=#56959F guibg=NONE ctermfg=6 ctermbg=NONE gui=NONE cterm=NONE
      hi TSVariable guifg=#907AA9 guibg=NONE ctermfg=5 ctermbg=NONE gui=NONE cterm=NONE
      hi TabLine guifg=#EA9D34 guibg=#B4637A ctermfg=3 ctermbg=1 gui=NONE cterm=NONE
      hi TabLineFill guifg=#575279 guibg=NONE ctermfg=8 ctermbg=NONE gui=NONE cterm=NONE
      hi TabLineSel guifg=#575279 guibg=NONE ctermfg=8 ctermbg=NONE gui=BOLD cterm=BOLD
      hi Tag guifg=#9CD8C3 guibg=NONE ctermfg=10 ctermbg=NONE gui=NONE cterm=NONE
      hi Title guifg=#C4A7E7 guibg=NONE ctermfg=13 ctermbg=NONE gui=NONE cterm=NONE
      hi Todo guifg=#569F84 guibg=NONE ctermfg=2 ctermbg=NONE gui=NONE cterm=NONE
      hi TooLong guifg=#575279 guibg=NONE ctermfg=7 ctermbg=NONE gui=NONE cterm=NONE
      hi Type guifg=#56959F guibg=NONE ctermfg=6 ctermbg=NONE gui=NONE cterm=NONE
      hi Typedef guifg=#9CD8C3 guibg=NONE ctermfg=10 ctermbg=NONE gui=NONE cterm=NONE
      hi Underlined guifg=#575279 guibg=NONE ctermfg=7 ctermbg=NONE gui=NONE cterm=NONE
      hi VertSplit guifg=#F2E9DE guibg=NONE ctermfg=NONE ctermbg=NONE gui=NONE cterm=NONE
      hi Visual guifg=NONE guibg=#EDD7BD ctermfg=NONE ctermbg=8 gui=NONE cterm=NONE
      hi VisualNOS guifg=NONE guibg=#575279 ctermfg=NONE ctermbg=8 gui=NONE cterm=NONE
      hi WarningMsg guifg=#EA9D34 guibg=NONE ctermfg=3 ctermbg=NONE gui=NONE cterm=NONE
      hi WildMenu guifg=#575279 guibg=#9CD8C3 ctermfg=8 ctermbg=10 gui=NONE cterm=NONE
      hi luaBraces guifg=#9893a5 guibg=NONE ctermfg=15 ctermbg=NONE gui=NONE cterm=NONE
      hi luaFuncCall guifg=#575279 guibg=NONE ctermfg=7 ctermbg=NONE gui=NONE cterm=NONE
      hi nixNamespacedBuiltin guifg=#907AA9 guibg=NONE ctermfg=5 ctermbg=NONE gui=NONE cterm=NONE
      hi nixStringDelimiter guifg=#EA9D34 guibg=NONE ctermfg=3 ctermbg=NONE gui=NONE cterm=NONE
      hi termColors guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE gui=NONE cterm=NONE

      set termguicolors
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
    '';*/
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
