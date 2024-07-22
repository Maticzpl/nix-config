{ lib, config, pkgs, ... }:

let
  cfg = config.userMods.appimage;
in

{
  options.userMods.appimage = {
    enable = lib.mkEnableOption "enable user module";
  };

  config = lib.mkIf cfg.enable {
    boot.binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };

    environment.systemPackages = [
      pkgs.appimage-run
    ];
  };
}
