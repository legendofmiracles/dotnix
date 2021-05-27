{ pkgs, config, ... }:

with import ./colors.nix { }; {
  xsession.scriptPath = ".xinitrc";
  xsession.initExtra = "feh .background-image --bg-fill"; # exec herbstluftwm"; # &; setxkbmap us -variant colemak";
  home.file."background-image" = {
    source = pkgs.fetchurl {
      url = "https://unsplash.com/photos/in9-n0JwgZ0/download?force=true";
      sha512 =
        "sha512-hoE3RtZHZMBN4fB6Ie4MiPrU+e/slaYVeMPGVJoXew6UadD3dfN1/WvAc4r5EhlajV2e0mhSrQ69GLwStMzFSA==";
    };
    target = ".background-image";
  };
  services.polybar = {
    enable = true;
    package = pkgs.polybarFull;
    script = ''
      polybar eDP1 &
    '';
    extraConfig = ''
      [colors]
      ; background = ''${xrdb:background}
      background = ${drbg}
      background-alt = #444444
      ; foreground =
      foreground = ${fg}
      foreground-alt = ''${xrdb:color7}
      primary = ${pink}
      secondary = #0000ff
      alert = #ffff00

      [bar/eDP1]
      ;monitor = eDP-1
      width = 100%
      height = 15
      ;offset-x = 1%
      ;offset-y = 1%
      ;radius = 15.5
      fixed-center = false
      tray-position = right

      background = ''${colors.background}
      foreground = ''${colors.foreground}

      line-size = 2
      line-color = #f00

      ;border-left-size = 16
      ;border-right-size = 16
      ;border-top-size = 8
      ;border-bottom-size = 0
      border-color = #00000000

      ;padding-left = 2
      ;padding-right = 2

      module-margin-left = 1
      module-margin-right = 1

      font-0 = "Hack:pixelsize=12;2"
      font-1 = "Font Awesome 5 Free:style=Regular:pixelsize=14;3"
      font-2 = "Font Awesome 5 Free:style=Solid:pixelsize=14;3"
      font-3 = "Font Awesome 5 Brands:pixelsize=14;3"

      modules-left = i3
      modules-right =  network-wlan battery-internal pulseaudio date separator power-menu

      wm-restack = i3

      override-redirect = false

      ;scroll-up = bspwm-desknext
      ;scroll-down = bspwm-deskprev

      scroll-up = i3wm-wsnext
      scroll-down = i3wm-wsprev

      cursor-click = pointer
      cursor-scroll = ns-resize

      ;enable-ipc = true

      [module/network-wlan]
      type = internal/network
      interface = wlp0s20f3
      format-connected = %{F${pink}}%{F-} <label-connected>
      label-connected =  %essid%
      label-connected-foreground = #eefafafa
      label-disconnected = not connected
      label-disconnected-foreground = #66ffffff
      animation-packetloss-framerate = 500
      interval = 10.0;


      [module/battery-internal]
      type = internal/battery

      ; This is useful in case the battery never reports 100% charge
      ; full-at = 99

      ; Use the following command to list batteries and adapters:
      ; $ ls -1 /sys/class/power_supply/
      battery = BAT0
      adapter = AC

      poll-interval = 100

      time-format = %H:%M

      format-charging = <animation-charging> <label-charging>
      format-discharging = <ramp-capacity> <label-discharging>

      label-charging = %percentage%%

      label-discharging = %percentage%%

      label-full = %{F${pink}}%{F-} 100%

      ramp-capacity-0 =%{F${pink}}%{F-}
      ramp-capacity-1 =%{F${pink}}%{F-}
      ramp-capacity-2 =%{F${pink}}%{F-}
      ramp-capacity-3 =%{F${pink}}%{F-}
      ramp-capacity-4 =%{F${pink}}%{F-}

      bar-capacity-width = 10

      animation-charging-0 =%{F${pink}}%{F-}
      animation-charging-1 =%{F${pink}}%{F-}
      animation-charging-2 =%{F${pink}}%{F-}
      animation-charging-3 =%{F${pink}}%{F-}
      animation-charging-4 =%{F${pink}}%{F-}
      ; Framerate in milliseconds
      animation-charging-framerate = 500

      animation-discharging-0 =%{F${pink}}%{F-}
      animation-discharging-1 =%{F${pink}}%{F-}
      animation-discharging-2 =%{F${pink}}%{F-}
      animation-discharging-3 =%{F${pink}}%{F-}
      animation-discharging-4 =%{F${pink}}%{F-}

      animation-discharging-framerate = 500

      [module/pulseaudio]
      type = internal/pulseaudio

      use-ui-max = true

      interval = 5

      format-volume = <ramp-volume> <label-volume>

      label-muted = %{F${pink}}%{F-} off

      ramp-volume-0 =%{F${pink}}%{F-}
      ramp-volume-1 =%{F${pink}}%{F-}
      ramp-volume-2 =%{F${pink}}%{F-}

      click-right = pavucontrol &


      [module/power-menu]
      type = custom/menu

      expand-right = true

      menu-0-0 ="|"
      menu-0-0-exec =
      menu-0-1 ="%{F${pink}}%{F-}"
      menu-0-1-exec = systemctl suspend
      menu-0-2 = "%{F${pink}}%{F-}"
      menu-0-2-exec = reboot
      menu-0-3 = "%{F${pink}}%{F-}"
      menu-0-3-exec = shutdown now
      menu-0-4 = "%{F${pink}}%{F-}"
      menu-0-4-exec = loginctl lock-session

      format =<menu>  <label-toggle>

      label-open = "%{F${pink}}%{F-}"

      label-close = "%{F${pink}}%{F-}"


      label-separator = "  "

      [settings]
      screenchange-reload = true
      pseudo-transparency = true

      [global/wm]
      margin-top = 0
      margin-bottom = 0

      [module/i3]
      type = internal/i3
      format = <label-state> <label-mode>
      index-sort = true
      wrapping-scroll = false

      label-mode-padding = 2
      label-mode-foreground = #000

      label-focused = %index%
      label-focused-background = ${pink}
      label-focused-underline = ''${colors.primary}
      label-focused-padding = 2

      label-unfocused = %index%
      label-unfocused-padding = 2

      label-visible = %index%
      label-visible-background = ''${self.label-focused-background}
      label-visible-underline = ''${self.label-focused-underline}
      label-visible-padding = ''${self.label-focused-padding}

      label-urgent = %index%
      label-urgent-background = ''${colors.alert}
      label-urgent-padding = 2
    '';
  };
  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;
    config = null;
    extraConfig = ''
      set $mod Mod4
      font pango:Cascadia Mono PL 10

      # Use pactl to adjust volume in PipeWire (also works with pulse).
      set $refresh_i3status killall -SIGUSR1 i3status
      bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10% && $refresh_i3status
      bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10% && $refresh_i3status
      bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle && $refresh_i3status
      bindsym XF86AudioMicMute exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status

      # Use Mouse+$mod to drag floating windows to their wanted position
      floating_modifier $mod

      # start a terminal
      bindsym $mod+Return exec alacritty

      # kill focused window
      bindsym $mod+Shift+q kill

      # starts flameshot (a screenshot tool)
      bindsym $mod+q exec flameshot gui

      # start rofi (a program launcher)
      bindsym $mod+d exec "rofi -show combi"
      bindsym $mod+c exec "rofi -show calc"

      bindsym $mod+h focus left
      bindsym $mod+n focus down
      # change focus
      bindsym $mod+e focus up
      bindsym $mod+i focus right

      bindsym $mod+Shift+h move left
      bindsym $mod+Shift+n move down
      bindsym $mod+Shift+e move up
      bindsym $mod+Shift+i move right

      # split in horizontal orientation
      bindsym $mod+f split h

      # split in vertical orientation
      bindsym $mod+v split v

      # enter fullscreen mode for the focused container
      bindsym $mod+t fullscreen toggle

      # change container layout (stacked, tabbed, toggle split)
      #bindsym $mod+Shift+s layout stacking
      #bindsym $mod+control+s layout tabbed
      #bindsym $mod+s layout toggle split

      # toggle tiling / floating
      bindsym $mod+Shift+space floating toggle

      # change focus between tiling / floating windows
      bindsym $mod+space focus mode_toggle

      # focus the parent container
      #bindsym $mod+a focus parent

      # focus the child container
      #bindsym $mod+d focus child

      # Define names for default workspaces for which we configure key bindings later on.
      # We use variables to avoid repeating the names in multiple places.
      set $ws1 "1"
      set $ws2 "2"
      set $ws3 "3"
      set $ws4 "4"
      set $ws5 "5"
      set $ws6 "6"
      set $ws7 "7"
      set $ws8 "8"
      set $ws9 "9"
      set $ws10 "10"

      bindsym $mod + Tab workspace back_and_forth

      # switch to workspace
      bindsym $mod+1 workspace number $ws1
      bindsym $mod+2 workspace number $ws2
      bindsym $mod+3 workspace number $ws3
      bindsym $mod+4 workspace number $ws4
      bindsym $mod+5 workspace number $ws5
      bindsym $mod+6 workspace number $ws6
      bindsym $mod+7 workspace number $ws7
      bindsym $mod+8 workspace number $ws8
      bindsym $mod+9 workspace number $ws9
      bindsym $mod+0 workspace number $ws10

      # move focused container to workspace
      bindsym $mod+Shift+1 move container to workspace number $ws1
      bindsym $mod+Shift+2 move container to workspace number $ws2
      bindsym $mod+Shift+3 move container to workspace number $ws3
      bindsym $mod+Shift+4 move container to workspace number $ws4
      bindsym $mod+Shift+5 move container to workspace number $ws5
      bindsym $mod+Shift+6 move container to workspace number $ws6
      bindsym $mod+Shift+7 move container to workspace number $ws7
      bindsym $mod+Shift+8 move container to workspace number $ws8
      bindsym $mod+Shift+9 move container to workspace number $ws9
      bindsym $mod+Shift+0 move container to workspace number $ws10

      # reload the configuration file
      bindsym $mod+Shift+c reload
      # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
      bindsym $mod+Shift+r restart

      # resize window (you can also use the mouse for that)
      mode "resize" {
              # These bindings trigger as soon as you enter the resize mode

              # Pressing left will shrink the window’s width.
              # Pressing right will grow the window’s width.
              # Pressing up will shrink the window’s height.
              # Pressing down will grow the window’s height.
              #bindsym j resize shrink width 10 px or 10 ppt
              #bindsym k resize grow height 10 px or 10 ppt
              #bindsym l resize shrink height 10 px or 10 ppt
              #bindsym semicolon resize grow width 10 px or 10 ppt

              # same bindings, but for the arrow keys
              bindsym Left resize shrink width 10 px or 10 ppt
              bindsym Down resize grow height 10 px or 10 ppt
              bindsym Up resize shrink height 10 px or 10 ppt
              bindsym Right resize grow width 10 px or 10 ppt

              # back to normal: Enter or Escape or $mod+r
              bindsym Return mode "default"
              bindsym Escape mode "default"
              bindsym $mod+r mode "default"
      }



      # class                 border  backgr. text    indicator child_border
      client.focused          ${pink} ${pink} ${fg}   #2e9ef4   ${pink} 
      client.focused_inactive #333333 #5f676a #ffffff #484e50   #5f676a
      client.unfocused        ${drbg} #222222 #888888 #292d2e   #222222
      client.urgent           #2f343a #900000 #ffffff #900000   #900000
      client.placeholder      #000000 #0c0c0c #ffffff #000000   #0c0c0c

      bindsym $mod+r mode "resize"

      # splash config
      for_window [class="SPLASH"] border none
      for_window [class="SPLASH"] floating enable
      for_window [class="Conky"] border none


      # no titlebar
      #for_window [class="^.*"] border pixel 1
      new_window 1pixel

      for_window [instance=origin.exe] floating enable
    '';
  };
  programs.rofi = {
    package =
      pkgs.rofi.override { plugins = with pkgs; [ rofi-calc rofi-emoji ]; };
    enable = true;
    extraConfig = {
      modi = "combi,calc";
      combi-modi = "drun,run,window,file-browser,ssh,keys,emoji";
    };
    font = "Cascadia Code 10";
    colors = {
      rows = {
        normal = {
          background = bg;
          foreground = fg;
          backgroundAlt = bg;
          highlight = {
            background = pink;
            foreground = fg;
          };
        };

      };
      window = {
        background = bg;
        separator = pink;
        border = pink;
      };
    };
  };
  services.flameshot.enable = true;
}
