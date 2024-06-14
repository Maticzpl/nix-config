{ lib, config, pkgs, ... }:

 # group = {
 #    "col.border_active" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
let
    cfg = config.userMods.hyprland.xremap;
    color_special = [
      { launch = ["hyprctl" "keyword" "general:col.active_border" "rgba(ff33ccee) rgba(aa00ffee) 45deg"]; }
      { launch = ["hyprctl" "keyword" "group:col.border_active" "rgba(ff33ccee) rgba(aa00ffee) 45deg"]; }
    ];
    color_resize = [
      { launch = ["hyprctl" "keyword" "general:col.active_border" "rgba(ffcc33ee) rgba(ff9900ee) 45deg"]; }
      { launch = ["hyprctl" "keyword" "group:col.border_active" "rgba(ffcc33ee) rgba(ff9900ee) 45deg"]; }
    ];
    color_default = [
      { launch = ["hyprctl" "keyword" "general:col.active_border" "rgba(33ccffee) rgba(00ff99ee) 45deg"]; }
      { launch = ["hyprctl" "keyword" "group:col.border_active" "rgba(33ccffee) rgba(00ff99ee) 45deg"]; }
    ];
in

{
    options.userMods.hyprland.xremap = {
        enable = lib.mkEnableOption "enable user module";
    };

    config = lib.mkIf cfg.enable {

        services.xremap = {
            withWlroots = true;
        };

        services.xremap.config.keymap = [
            {
                name = "Hyprland nav";
                mode = "default";
                remap = {
                  "SUPER-SPACE" = [
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
                  "H" = "SUPER-H";
                  "J" = "SUPER-J";
                  "K" = "SUPER-K";
                  "L" = "SUPER-L";

                  # Move to workspaces
                  "1" = "SUPER-1";
                  "2" = "SUPER-2";
                  "Q" = "SUPER-Q"; # Special

                  # Move cursor in group
                  "P" = "SUPER-CONTROL-H";
                  "N" = "SUPER-CONTROL-L";

                  "F" = "SUPER-F"; # Firefox
                  "T" = "SUPER-T"; # Terminal
                  "E" = "SUPER-E"; # File explorer
                  "R" = [ 
                    { "set_mode" = "default"; }
                    "SUPER-R"
                  ] ++ color_default; # Run

                  "KEY_W".remap = {
                    # Move to workspaces
                    "1" = "SUPER-SHIFT-1";
                    "2" = "SUPER-SHIFT-2";
                    "Q" = "SUPER-SHIFT-Q"; # Special

                    "H" = "SUPER-SHIFT-H"; 
                    "J" = "SUPER-SHIFT-J";
                    "K" = "SUPER-SHIFT-K";
                    "L" = "SUPER-SHIFT-L";

                    "C" = "SUPER-SHIFT-C"; # Close
                    "G" = "SUPER-SHIFT-G"; # Group
                    "S" = "SUPER-SHIFT-S"; # Split change
                    "M" = "SUPER-SHIFT-M"; # Maximize

                    "F".remap = {
                      "L" = "SUPER-SHIFT-F";         #FLoat
                      "S" = "SUPER-SHIFT-CONTROL-M"; #FullScreen
                      "F" = "SUPER-SHIFT-CONTROL-F"; #FullscreenFake
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
                  "H" = "SUPER-SHIFT-LEFT";
                  "J" = "SUPER-SHIFT-DOWN";
                  "K" = "SUPER-SHIFT-UP"; 
                  "L" = "SUPER-SHIFT-RIGHT"; 
                };
            }

            {
                name = "Spotify";
                application = {
                  only = "Spotify";
                };
                mode = "default";

                remap = {
                  "SPACE" = { "set_mode" = "spotify"; };
                };
            }
            {
                name = "Spotify Input";
                application = {
                  only = "Spotify";
                };
                mode = "spotifyInput";

                remap = {
                  "Enter" = [
                    { "set_mode" = "spotify"; }
                    "TAB" "TAB" "TAB" "DOWN" "UP"
                  ];
                  "Esc" = { "set_mode" = "default"; };
                };
            }
            {
                name = "Spotify special";
                mode = "spotify";
                application = {
                  only = "Spotify";
                };
                remap = {
                  "Esc" = { "set_mode" = "default"; };

                  "H" = "LEFT";
                  "J" = "DOWN";
                  "K" = "UP"; 
                  "L" = "RIGHT"; 

                  "F" = "SHIFT-RIGHT"; # Forward
                  "B" = "SHIFT-LEFT"; # Backwards

                  "N" = "CTRL-RIGHT"; # Next song
                  "P" = "CTRL-LEFT"; # Previous song

                  "S" = "CTRL-S"; # Shuffle
                  "R" = "CTRL-R"; # Repeat

                  "T" = "ALT-SHIFT-R"; # Toggle sidebar

                  # Navigate (Go)
                  "G".remap = {
                      "H" = "ALT-SHIFT-H"; # Home
                      "P" = [
                        "ALT-SHIFT-H"
                        "CTRL-ALT-F" # Playlists
                        { "set_mode" = "spotifyInput"; }
                      ];
                      "S" = [
                        "CTRL-K"
                        { "set_mode" = "spotifyInput"; }
                      ]; # Quick Search
                  };
                };
            }
        ];
    };
}
