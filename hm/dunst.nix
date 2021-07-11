{ pkgs, config, lib, ... }:

with import ./colors.nix { }; {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        padding = 8;
        markup = "full";
        alignment = "center";
        word_wrap = "yes";
        horizontal_padding = 8;
        show_indicators = false;
        frame_width = 2;
        format = "<b>%s</b>\\n\\n%b";
        font = "Sarasa Gothic J 10.4";
        frame_color = "#${pink}";
        separator_color = "auto";
        icon_position = "left";
        max_icon_size = 80;
        geometry = "330x5-8+25";
      };

      urgency_low = {
        foreground = "${fg}";
        background = "${bg}";
        frame_color = "${pink}";
        timeout = 2;
      };

      urgency_normal = {
        foreground = "${fg}";
        background = "${bg}";
        frame_color = "${pink}";
        timeout = 4;
      };

      urgency_critical = {
        foreground = "${fg}";
        background = "${bg}";
        frame_color = "${pink}";
      };
    };
  };
}
