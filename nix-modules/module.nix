{ lib, config, pkgs, ... }:

let
  cfg = config.userMods.MODULENAME;
in

{
  options.userMods.MODULENAME = {
    enable = lib.mkEnableOption "enable user module";
  };

  config = lib.mkIf cfg.enable { };
}
