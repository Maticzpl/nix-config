{ lib, config, pkgs, ... }:

let
    cfg = config.MODULENAME;
in

{
    options.MODULENAME = {
        enable = lib.mkEnableOption "enable user module";
    };

    config = lib.mkIf cfg.enable {
    };
}
