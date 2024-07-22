{ lib, config, pkgs, home-manager, ... }:

let
  cfg = config.userMods.fish;
in

{
  options.userMods.fish = {
    enable = lib.mkEnableOption "enable user module";
    username = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "User for which to set the config.fish file";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.fish
    ];

    programs.bash = {
      interactiveShellInit = /*bash*/ ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

    home-manager.users."${cfg.username}" = {
      home.file = {
        ".config/fish/config.fish".text = /*bash*/ ''
          if status is-interactive
            fish_vi_key_bindings
          end

          zoxide init --cmd cd fish | source
        '';
      };
    };
  };
}
