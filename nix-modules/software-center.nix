{ lib, config, pkgs, ... }:

let
  # # IMPURE!!!!!!!!!!!!
  # nix-software-center = import (pkgs.fetchFromGitHub {
  #     owner = "snowfallorg";
  #     repo = "nix-software-center";
  #     rev = "0.1.2";
  #     sha256 = "xiqF1mP8wFubdsAQ1BmfjzCgOD3YZf7EGWl9i69FTls=";
  # }) 
  # {};

  discover-wrapped = pkgs.symlinkJoin {
    name = "discover-flatpak-backend";
    paths = [ pkgs.libsForQt5.discover ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/plasma-discover --add-flags "--backends flatpak"
    '';
  };

  cfg = config.userMods.softwareCenter;
in

{
  options.userMods.softwareCenter = {
    enable = lib.mkEnableOption "enable user module";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      # nix-software-center
      discover-wrapped
    ];
  };
}
