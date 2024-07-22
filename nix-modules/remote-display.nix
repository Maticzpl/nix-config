{ lib, config, pkgs, ... }:

let
  cfg = config.userMods.remoteDisplay;
in

{
  options.userMods.remoteDisplay = {
    enable = lib.mkEnableOption "enable user module";
    username = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "User for which to set the config file";
    };
  };

  config = lib.mkIf cfg.enable {
    # nothing works on kde 💀
    environment.systemPackages = [
      # pkgs.krfb
      # pkgs.virtscreen # broken

    ];
    # services.xrdp.enable = true;
    # #services.xrdp.defaultWindowManager = "startplasma-wayland";
    # services.xrdp.openFirewall = true;
    # services.xrdp.confDir = /home/${cfg.username}/.config/xrdp/;
    #
    # home-manager.users."${cfg.username}" = {
    #   home.file = {
    #     ".config/xrdp/xrdp.ini".text = ''
    #
    #     '';
    #   };
    # };
  };
}
