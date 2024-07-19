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

            #kitty -c "~/.config/hypr/kittyconfigbg.conf" --class="kitty-bg" /home/${cfg.username}/.config/hypr/cava.sh

            home.file = {
                ".config/hypr/kittyconfigbg.conf".text = ''
                    background_opacity 0.0
                    font_size 8.0
                    confirm_os_window_close 0
                '';
                ".config/hypr/cava.sh" = {
                    text = /*bash*/ ''
                        #!/usr/bin/env bash
                        sleep 1 && cava
                    '';
                    executable = true;
                };
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
        };
    };
}
