{ lib, config, pkgs, inputs, ... }:

let
    cfg = config.userMods.hyprland.cavabg;
in

{
    options.userMods.hyprland.cavabg = {
        enable = lib.mkEnableOption "enable user module";
        username = lib.mkOption {
            default = "";
            type = lib.types.str;
            description = "User for which to set the cava backgroun";
        };
    };

    config = lib.mkIf cfg.enable {
        home-manager.users."${cfg.username}" = {
            home.packages = with pkgs; [
                kitty
                cava
            ];

            home.file = {
                ".config/hypr/kittyconfigbg.conf".text = ''
                    background_opacity 0.0
                    font_size 5.0
                    confirm_os_window_close 0
                '';
                ".config/hypr/cava.sh" = {
                    text = /*bash*/ ''
                        #!/usr/bin/env bash
                        sleep 1 && cava
                    '';
                    executable = true;
                };

                ".config/cava/config".text = ''
                    [general]
                     autosens = 0
                     sensitivity = 200
                     bars = 0
                     bar_width = 1
                     bar_spacing = 0
                     lower_cutoff_freq = 20
                     higher_cutoff_freq = 17000

                    [input]

                    [output]

                    [color]
                    # foreground = "#1177FFdd"
                    foreground = blue

                    [smoothing]
                     noise_reduction = 0

                    [eq]
                     1 = 2 
                     2 = 3
                     3 = 3 
                     4 = 3
                     5 = 2 

                '';
            };

            wayland.windowManager.hyprland = {
                plugins = [
                    inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
                ];

                settings = {
                    plugin = {
                        hyprwinwrap = {
                            class = "kitty-bg";
                        };
                    };
                };
            };

            xdg.desktopEntries.cava = {
                name = "cava";
                exec = "sh -c \"pkill cava; KITTY_DISABLE_WAYLAND=1 kitty -c ~/.config/hypr/kittyconfigbg.conf --class=kitty-bg ~/.config/hypr/cava.sh\"";

                terminal = false;
                type = "Application";
                categories = ["AudioVideo"];
                mimeType = [];
            };
        };
    };
}
