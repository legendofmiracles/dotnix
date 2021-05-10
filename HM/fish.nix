{ pkgs, config, ... }:

{
  programs.fish.enable = true;
  programs.fish.plugins = [
    {
      name = "z";
      src = pkgs.fetchFromGitHub {
        owner = "jethrokuan";
        repo = "z";
        rev = "e0e1b9dfdba362f8ab1ae8c1afc7ccf62b89f7eb";
        sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
      };
    }
    {
      name = "fish-async-prompt";
      src = pkgs.fetchFromGitHub {
        owner = "acomagu";
        repo = "fish-async-prompt";
        rev = "v1.2.0";
        sha256 = "0dbnir6jbwjpjalz14snzd3cgdysgcs3raznsijd6savad3qhijc";
      };
    }
    #pkgs.fishPlugins.fzf-fish
    #pkgs.fishPlugins.done
  ];
  programs.fish.shellAbbrs = {
    c = "vim ~/dotnix/";
    ls = "ls --color";
    rm = "rm -v";
    cp = "cp -v";
    mv = "mv -v";
    clip = "xclip -selection c";
    store-alive = "nix-store -q --roots";
  };

  programs.fish.shellInit = ''
        # loads secrets at runtime
        source /run/secrets/variables

        set -g __fish_git_prompt_show_informative_status 1
        set -g __fish_git_prompt_hide_untrackedfiles 1

        set -g __fish_git_prompt_color_branch magenta
        set -g __fish_git_prompt_showupstream "informative"
        set -g __fish_git_prompt_char_upstream_ahead "↑"
        set -g __fish_git_prompt_char_upstream_behind "↓"
        set -g __fish_git_prompt_char_upstream_prefix ""

        set -g __fish_git_prompt_char_stagedstate " ●"
        set -g __fish_git_prompt_char_dirtystate " ✚"
        set -g __fish_git_prompt_char_untrackedfiles " …"
        set -g __fish_git_prompt_char_conflictedstate " ✖"
        set -g __fish_git_prompt_char_cleanstate " ✔"

        set -g __fish_git_prompt_color_dirtystate blue
        set -g __fish_git_prompt_color_stagedstate yellow
        set -g __fish_git_prompt_color_invalidstate red
        set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal
        set -g __fish_git_prompt_color_cleanstate green
        # cat ~/dots/.cache/wal/sequences
    # https://github.com/jichu4n/fish-command-timer/blob/master/conf.d/fish_command_timer.fish
    if not set -q fish_command_timer_enabled
      set fish_command_timer_enabled 1
    end
    if not set -q fish_command_timer_status_enabled
      set fish_command_timer_status_enabled 0
    end
    if not set -q fish_command_timer_color
      set fish_command_timer_color blue
    end
    # Similarly, the color to use for displaying success and failure exit statuses.
    if not set -q fish_command_timer_success_color
      set fish_command_timer_success_color green
    end
    if not set -q fish_command_timer_fail_color
      set fish_command_timer_fail_color $fish_color_status
    end
    if not set -q fish_command_timer_time_format
      set fish_command_timer_time_format '%b %d %I:%M%p'
    end

    if not set -q fish_command_timer_millis
      set fish_command_timer_millis 1
    end
    if not set -q fish_command_timer_export_cmd_duration_str
      set fish_command_timer_export_cmd_duration_str 1
    end
    if begin
         set -q fish_command_timer_export_cmd_duration_str; and \
         [ "$fish_command_timer_export_cmd_duration_str" -ne 0 ]
       end
      set CMD_DURATION_STR
    end
    if not set -q fish_command_timer_min_cmd_duration
      set fish_command_timer_min_cmd_duration 0
    end
    if date --date='@0' '+%s' > /dev/null 2> /dev/null
      # Linux.
      function fish_command_timer_print_time
        date --date="@$argv[1]" +"$fish_command_timer_time_format"
      end
    else if date -r 0 '+%s' > /dev/null 2> /dev/null
      # macOS / BSD.
      function fish_command_timer_print_time
        date -r "$argv[1]" +"$fish_command_timer_time_format"
      end
    else
      echo 'No compatible date commands found, not enabling fish command timer'
      set fish_command_timer_enabled 0
    end

    if type string > /dev/null 2> /dev/null
      function fish_command_timer_strlen
        string length "$argv[1]"
      end
    else if expr length + "1" > /dev/null 2> /dev/null
      function fish_command_timer_strlen
        expr length + "$argv[1]"
      end
    else if type wc > /dev/null 2> /dev/null; and type tr > /dev/null 2> /dev/null
      function fish_command_timer_strlen
        echo -n "$argv[1]" | wc -c | tr -d ' '
      end
    else
      echo 'No compatible string, expr, or wc commands found, not enabling fish command timer'
      set fish_command_timer_enabled 0
    end

    # Computes whether the postexec hooks should compute command duration.
    function fish_command_timer_should_compute
      begin
        set -q fish_command_timer_enabled; and \
        [ "$fish_command_timer_enabled" -ne 0 ]
      end; or \
      begin
        set -q fish_command_timer_export_cmd_duration_str; and \
        [ "$fish_command_timer_export_cmd_duration_str" -ne 0 ]
      end
    end

    # Computes the command duration string (e.g. "3m5s016").
    function fish_command_timer_compute_cmd_duration_str
      set -l SEC 1000
      set -l MIN 60000
      set -l HOUR 3600000
      set -l DAY 86400000

      set -l num_days (math -s0 "$CMD_DURATION / $DAY")
      set -l num_hours (math -s0 "$CMD_DURATION % $DAY / $HOUR")
      set -l num_mins (math -s0 "$CMD_DURATION % $HOUR / $MIN")
      set -l num_secs (math -s0 "$CMD_DURATION % $MIN / $SEC")
      set -l num_millis (math -s0 "$CMD_DURATION % $SEC")
      set -l cmd_duration_str ""
      if [ $num_days -gt 0 ]
        set cmd_duration_str {$cmd_duration_str}{$num_days}"d "
      end
      if [ $num_hours -gt 0 ]
        set cmd_duration_str {$cmd_duration_str}{$num_hours}"h "
      end
      if [ $num_mins -gt 0 ]
        set cmd_duration_str {$cmd_duration_str}{$num_mins}"m "
      end
      set -l num_millis_pretty \'\'
      if begin
          set -q fish_command_timer_millis; and \
          [ "$fish_command_timer_millis" -ne 0 ]
         end
        set num_millis_pretty (printf '%03d' $num_millis)
      end
      set cmd_duration_str {$cmd_duration_str}{$num_secs}s{$num_millis_pretty}
      echo $cmd_duration_str
    end

    # The fish_postexec event is fired after executing a command line.
    function fish_command_timer_postexec -e fish_postexec
      set -l last_status $status
      set -l command_end_time (date '+%s')

      if not fish_command_timer_should_compute
        return
      end

      set -l cmd_duration_str (fish_command_timer_compute_cmd_duration_str)
      if begin
          set -q fish_command_timer_export_cmd_duration_str; and \
          [ "$fish_command_timer_export_cmd_duration_str" -ne 0 ]
         end
        set CMD_DURATION_STR "$cmd_duration_str"
      end

      if not begin
          set -q fish_command_timer_enabled; and \
          [ "$fish_command_timer_enabled" -ne 0 ]
          end
        return
      end
      if set -q fish_command_timer_min_cmd_duration; and \
          [ "$fish_command_timer_min_cmd_duration" -gt "$CMD_DURATION" ]; and begin
            [ "$last_status" -eq 0 ]; or \
            not set -q fish_command_timer_status_enabled; or \
            [ "$fish_command_timer_status_enabled" -eq 0 ]
          end
        return
      end

      # Compute timing string (e.g. [ 1s016 | Oct 01 11:11PM ])
      set -l timing_str
      set -l now_str (fish_command_timer_print_time $command_end_time)
      if [ -n "$now_str" ]
        set timing_str "[ $cmd_duration_str | $now_str ]"
      else
        set timing_str "[ $cmd_duration_str ]"
      end
      set -l timing_str_length (fish_command_timer_strlen "$timing_str")

      # Compute timing string with color.
      set -l timing_str_colored
      if begin
           set -q fish_command_timer_color; and \
           [ -n "$fish_command_timer_color" ]
         end
        set timing_str_colored (set_color $fish_command_timer_color)"$timing_str"(set_color normal)
      else
        set timing_str_colored "$timing_str"
      end

      # Compute status string (e.g. [ SIGINT ])
      set -l status_str ""
      if begin
          set -q fish_command_timer_status_enabled; and \
          [ "$fish_command_timer_status_enabled" -ne 0 ]
         end
        set -l signal (__fish_status_to_signal $last_status)
        set status_str "[ $signal ]"
      end
      set -l status_str_length (fish_command_timer_strlen "$status_str")

      # Compute status string with color.
      set -l status_str_colored
      if begin
          [ $last_status -eq 0 ]; and \
          set -q fish_command_timer_success_color; and \
          [ -n "$fish_command_timer_success_color" ]
          end
        set status_str_colored (set_color $fish_command_timer_success_color)"$status_str"(set_color normal)
      else if begin
          [ $last_status -ne 0 ]; and \
          set -q fish_command_timer_fail_color; and \
          [ -n "$fish_command_timer_fail_color" ]
          end
        set status_str_colored (set_color --bold $fish_command_timer_fail_color)"$status_str"(set_color normal)
      else
        set status_str_colored "$status_str"
      end

      # Combine status string and timing string.
      set -l output_length (math $timing_str_length + $status_str_length + 1)

      # Move to the end of the line. This will NOT wrap to the next line.
      echo -ne "\033["{$COLUMNS}"C"
      # Move back output_length columns.
      echo -ne "\033["{$output_length}"D"
      # Finally, print output.
      echo -e "$status_str_colored $timing_str_colored"
    end
  '';

  programs.fish.promptInit = ''

  '';

  programs.fish.functions = {
    r = ''
      git -C $NIXOS_CONFIG diff; sudo nixos-rebuild switch --flake $NIXOS_CONFIG
    '';
    bne = ''
      sed -i 0,/"# Last line"/{s/"# Last line"/"$argv[1]\n    # Last line"/} ~/dotnix/HM/home.nix
    '';
    fish_prompt = ''
        set -l last_pipestatus $pipestatus
        set -lx __fish_last_status $status # Export for __fish_print_pipestatus.
        set -l normal (set_color normal)

        # Color the prompt differently when we're root
        set -l color_cwd $fish_color_cwd
        set -l suffix '>'
        if functions -q fish_is_root_user; and fish_is_root_user
            if set -q fish_color_cwd_root
                set color_cwd $fish_color_cwd_root
            end
            set suffix '#'
        end

        # If we're running via SSH, change the host color.
        set -l color_host $fish_color_host
        if set -q SSH_TTY
            set color_host $fish_color_host_remote
        end

        # Write pipestatus
        # If the status was carried over (e.g. after `set`), don't bold it.
        set -l bold_flag --bold
        set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
        if test $__fish_prompt_status_generation = $status_generation
            set bold_flag
        end
        set __fish_prompt_status_generation $status_generation
        set -l prompt_status (__fish_print_pipestatus "[" "]" "|" (set_color $fish_color_status) (set_color $bold_flag $fish_color_status) $last_pipestatus)

        # echo -n -s (set_color $fish_color_user) "$USER" $normal @ (set_color $color_host) (prompt_hostname) $normal ' ' (set_color $color_cwd) (prompt_pwd) $normal (fish_vcs_prompt) $normal " "$prompt_status $suffix " "
      set -l nix_shell_info (
        if test -n "$IN_NIX_SHELL"
          echo -n "<nix-shell> "
        end
      )
      #  set last_status $status

      printf '%s' $nix_shell_info
      set_color $fish_color_cwd
      printf '%s' (prompt_pwd)
      set_color normal

      printf '%s ' (__fish_git_prompt)
      set_color FF217C
      printf '%s' $prompt_status
      printf "> "
      set_color normal
    '';
  };
}
