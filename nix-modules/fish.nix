{ lib, config, pkgs, ... }:

let
    cfg = config.userMods.fish;
in

{
    options.userMods.fish = {
        enable = lib.mkEnableOption "enable user module";
    };

    config = lib.mkIf cfg.enable {
      programs.bash = {
          interactiveShellInit = ''
              if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
              then
                  shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
                  exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
              fi
          '';
      };
    };
}
