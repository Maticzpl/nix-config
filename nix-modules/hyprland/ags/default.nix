{ lib, config, inputs, pkgs, ... }:

let
    cfg = config.userMods.hyprland.ags;
in

{
    options.userMods.hyprland.ags = {
        enable = lib.mkEnableOption "enable user module";

        username = lib.mkOption {
            default = "";
            type = lib.types.str;
            description = "User for which to set the config.fish file";
        };
    };


    config = lib.mkIf cfg.enable {

        home-manager.users."${cfg.username}" = {
            imports = [ inputs.ags.homeManagerModules.default ];        

            programs.ags = {
                enable = true;
            };

            xdg.configFile."ags/config.js".source = ./config.js;
            xdg.configFile."ags/style.css".source = ./style.css;

            wayland.windowManager.hyprland = {
                settings = {
                    exec-once = [ 
                        "ags"
                    ];
                };
            };
        };
    };
}
