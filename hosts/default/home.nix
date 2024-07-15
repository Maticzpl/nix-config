{ config, pkgs, inputs, ... }:
let
    stable = import inputs.nixpkgs-stable { system = pkgs.system; config.allowUnfree = true; };
    unstableAF = import inputs.nixpkgs-very-fucking-unstable { system = pkgs.system; config.allowUnfree = true; };
in
{
  imports = [
    ../../home-manager-modules
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "maticzpl";
  home.homeDirectory = "/home/maticzpl";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = (with pkgs; [
    papirus-icon-theme
    blender-hip
    kate
    (vesktop.override { withSystemVencord = false; })
    obs-studio
    steam


    spotify
    curlWithGnuTls
    bitwarden
    firefox
    flatpak
    # gitkraken
    git-graph
    fastfetch
    dconf-editor
    obsidian
    vscode
    tldr
    htop

    bambu-studio
    filezilla
    protonup-qt
    prismlauncher
    wlx-overlay-s
    bottles
    legendary-gl
    heroic
    spotdl
    ytmdl
    zoxide
    mpv
    calibre
    imhex
    mission-center
    qdirstat

    gimp
    krita
    davinci-resolve
    protontricks
    wlx-overlay-s

    android-studio

    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ]) ++ 
  (with unstableAF; [

  ]) ++
  (with stable; [
    gitkraken
    # steam
  ]);

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/maticzpl/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.git = {
    enable = true;
    userName = "Maticzpl";
    userEmail = "maticzpl06@gmail.com";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  wayland.windowManager.hyprland.settings = {
      monitor = [ 
          "DP-2,1920x1080,0x0,1"
          "DP-1,1280x800,400x1080,1"
          "HDMI-A-1,1920x1080,1920x0,1"
      ]; 
  };
  # dconf = {
  #   enable = true;
  #   settings = {
  #     "org/gnome/desktop/interface" = {
  #         color-scheme = "prefer-dark";
  #         gtk-theme = "Adwaita-dark";
  #     };
  #   };
  # };

  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "Breeze-Dark";
  #     package = pkgs.libsForQt5.breeze-gtk;
  #   };
  # };

}
