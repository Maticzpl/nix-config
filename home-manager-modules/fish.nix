{ lib, config, pkgs, ... }:

let
    cfg = config.userMods.fish;
in

{
    options.userMods.fish = {
        enable = lib.mkEnableOption "enable user module";
    };

    config = lib.mkIf cfg.enable {
      home.file = {
        ".config/fish/config.fish".text = ''
              if status is-interactive
                fish_vi_key_bindings
              end

              zoxide init fish | source
          '';
      };
    };
}
