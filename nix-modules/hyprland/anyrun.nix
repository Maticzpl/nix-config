{ lib, config, inputs, pkgs, ... }:

let
    cfg = config.userMods.hyprland.anyrun;
in

{
    options.userMods.hyprland.anyrun = {
        enable = lib.mkEnableOption "enable user module";

        username = lib.mkOption {
            default = "";
            type = lib.types.str;
            description = "User for home manager stuff";
        };
    };


    config = lib.mkIf cfg.enable {
        # nix.settings = {
        #     builders-use-substitutes = true;
        #     extra-substituters = [
        #         "https://anyrun.cachix.org"
        #     ];
        #
        #     extra-trusted-public-keys = [
        #         "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        #     ];
        # };

        home-manager.users."${cfg.username}" = {
            imports = [ inputs.anyrun.homeManagerModules.default ];        

            programs.anyrun = {
                enable = true;
                config = {
                    plugins = [
                        inputs.anyrun.packages.${pkgs.system}.applications
                        inputs.anyrun.packages.${pkgs.system}.rink
                        # "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/kidex"
                    ];
                    # x = { fraction = 0.5; };
                    # y = { fraction = 0.3; };
                    # width = { fraction = 0.3; };
                    # hideIcons = false;
                    # ignoreExclusiveZones = false;
                    # layer = "overlay";
                    # hidePluginInfo = false;
                    # closeOnClick = false;
                    # showResultsImmediately = false;
                    # maxEntries = null;
                };
                extraCss = /*css*/ ''
                    #window {
                        background: transparent;                          
                    }
                '';

                # extraConfigFiles."some-plugin.ron".text = '
                #     Config(
                #             // for any other plugin
                #             // this file will be put in ~/.config/anyrun/some-plugin.ron
                #             // refer to docs of xdg.configFile for available options
                #           )
                #     '';
            };
        };
    };
}
