{ lib, config, pkgs, ... }:

# group = {
#    "col.border_active" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
let
  cfg = config.userMods.hyprland.xremap;
  color_special = [
    { launch = [ "hyprctl" "keyword" "general:col.active_border" "rgba(ff33ccee) rgba(aa00ffee) 45deg" ]; }
    { launch = [ "hyprctl" "keyword" "group:col.border_active" "rgba(ff33ccee) rgba(aa00ffee) 45deg" ]; }
  ];
  color_resize = [
    { launch = [ "hyprctl" "keyword" "general:col.active_border" "rgba(ffcc33ee) rgba(ff9900ee) 45deg" ]; }
    { launch = [ "hyprctl" "keyword" "group:col.border_active" "rgba(ffcc33ee) rgba(ff9900ee) 45deg" ]; }
  ];
  color_default = [
    { launch = [ "hyprctl" "keyword" "general:col.active_border" "rgba(33ccffee) rgba(00ff99ee) 45deg" ]; }
    { launch = [ "hyprctl" "keyword" "group:col.border_active" "rgba(33ccffee) rgba(00ff99ee) 45deg" ]; }
  ];
  hyprctl = cmd: { launch = [ "hyprctl" "dispatch" cmd ]; };
in

{
  options.userMods.hyprland.xremap = {
    enable = lib.mkEnableOption "enable user module";
  };

  config = lib.mkIf cfg.enable {

    services.xremap = {
      withWlroots = true;
    };

    services.xremap.config.modmap = [
      {
        name = "Super";
        remap = {
          # "SUPER_L" = [ "F24" "SUPER_L" ];
          "SUPER_L" = {
            held = "SUPER_L";
            alone = "F24";
            alone_timeout_millis = 200;
          };
        };
      }
    ];

    services.xremap.config.keymap = [
      {
        name = "Hyprland nav";
        mode = "default";
        remap = {
          "KEY_F24" = [
            { set_mode = "super"; }
          ] ++ color_special;
        };
      }

      {
        name = "Hyprland super nav";
        mode = "super";
        remap = {
          "Esc" = [
            { set_mode = "default"; }
          ] ++ color_default;
          "SUPER-SPACE" = [
            { set_mode = "default"; }
          ] ++ color_default;

          # Move cursor
          "H" = hyprctl "movefocus l";
          "J" = hyprctl "movefocus d";
          "K" = hyprctl "movefocus u";
          "L" = hyprctl "movefocus r";

          # Move to workspaces
          "1" = hyprctl "exec hyprnome --previous";
          "2" = hyprctl "exec hyprnome";
          "Q" = hyprctl "togglespecialworkspace magic"; # Special

          # Move cursor in group
          "P" = hyprctl "changegroupactive b";
          "N" = hyprctl "changegroupactive f";

          "SHIFT-ESC" = hyprctl "exit";
          "SUPER-CTRL-ESC" = hyprctl "exec hyprlock";
          "ALT-ESC" = hyprctl "exec hyprlock & systemctl suspend";

          "F" = hyprctl "exec firefox"; # Firefox
          "T" = hyprctl "exec konsole"; # Terminal
          "E" = hyprctl "exec nautilus"; # File explorer
          "V" = hyprctl "exec vesktop";
          "R" = [
            { "set_mode" = "default"; }
            # hyprctl "exec anyrun"
            "SUPER-R"
          ] ++ color_default; # Run

          "KEY_W".remap = {
            # Move to workspaces
            "1" = hyprctl "exec hyprnome --previous --move";
            "2" = hyprctl "exec hyprnome --move";
            "Q" = hyprctl "movetoworkspace special:magic"; # Special

            "H" = hyprctl "movewindoworgroup l";
            "J" = hyprctl "movewindoworgroup d";
            "K" = hyprctl "movewindoworgroup u";
            "L" = hyprctl "movewindoworgroup r";

            "C" = hyprctl "killactive"; # Close
            "G" = hyprctl "togglegroup"; # Group
            "S" = hyprctl "togglesplit"; # Split change
            "M" = hyprctl "fullscreen 1"; # Maximize

            "F".remap = {
              "L" = "SUPER-SHIFT-F"; #FLoat
              "S" = hyprctl "fullscreen 0"; #FullScreen
              "F" = hyprctl "fullscreen 2"; #FullscreenFake
            };

            "R".remap = {
              "S" = [
                { "set_mode" = "resize"; }
              ] ++ color_resize;
            };
          };
        };
      }

      {
        name = "Hyprland super nav resize";
        mode = "resize";
        remap = {
          "Esc" = [
            { "set_mode" = "super"; }
          ] ++ color_special;
          "Enter" = [
            { "set_mode" = "super"; }
          ] ++ color_special;

          # Resize window
          "H" = hyprctl "resizeactive -10 0";
          "J" = hyprctl "resizeactive 0 10";
          "K" = hyprctl "resizeactive 0 -10";
          "L" = hyprctl "resizeactive 10 0";
        };
      }
    ];
  };
}
