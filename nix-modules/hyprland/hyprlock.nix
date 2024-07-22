{ lib, config, inputs, pkgs, ... }:

let
  cfg = config.userMods.hyprland.hyprlock;
in

{
  options.userMods.hyprland.hyprlock = {
    enable = lib.mkEnableOption "enable user module";

    username = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "User for home manager stuff";
    };

    wallpaper = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Wallpaper path";
    };

    mainMonitor = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Main monitor id";
    };
  };


  config = lib.mkIf cfg.enable {
    home-manager.users."${cfg.username}" = {

      home.packages = with pkgs; [
        hyprlock
      ];

      wayland.windowManager.hyprland.settings = {
        bind = [
          "$mod, Escape, exec, hyprlock"
          "$mod ALT, Escape, exec, hyprlock & systemctl suspend"
        ];
      };

      home.file = {
        ".config/hypr/hyprlock.conf".text = ''
          background {
              monitor =
              # supports png, jpg, webp (no animations, though)
              path = ${cfg.wallpaper}   
              color = rgba(25, 20, 20, 1.0)

              # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
              blur_passes = 2 # 0 disables blurring
              blur_size = 5
              noise = 0.03
              contrast = 0.8916
              brightness = 0.8172
              vibrancy = 0.1696
              vibrancy_darkness = 0.0
          }

          input-field {
              monitor = ${cfg.mainMonitor}
              size = 400, 50
              outline_thickness = 3
              dots_size = 0.3 # Scale of input-field height, 0.2 - 0.8
              dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
              dots_center = false
              dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
              outer_color = rgb(40, 40, 40)
              inner_color = rgb(32, 32, 32)
              font_color = rgb(238, 238, 238)
              fade_on_empty = false
              fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
              placeholder_text = Password... # Text rendered in the input box when it's empty.
              hide_input = false
              rounding = 15 # -1 means complete rounding (circle/oval)
              check_color = rgb(204, 136, 34)
              fail_color = rgb(204, 34, 34) # if authentication failed, changes outer_color and fail message color
              fail_text = $FAIL <b>($ATTEMPTS)</b> # can be set to empty
              fail_transition = 300 # transition time in ms between normal outer_color and fail_color
              capslock_color = -1
              numlock_color = -1
              bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
              invert_numlock = false # change color if numlock is off
              swap_font_color = false # see below

              position = 0, -20
              halign = center
              valign = center
          }
          label {
              monitor =
              text = $TIME
              text_align = center 
              color = rgba(238, 238, 238, 1.0)
              font_size = 60
              font_family = Noto Sans
              rotate = 0 # degrees, counter-clockwise
  
              position = 0, 80
              halign = center
              valign = center
          }
        '';
      };
    };
  };
}
