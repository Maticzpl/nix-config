  # Edit this configuration file to define what should be installed on
  # your system.  Help is available in the configuration.nix(5) man page
  # and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];

  userMods = {
    softwareCenter.enable = false;
    appimage.enable = true;
    audio = {
        enable = false;
        calfConfig = "/home/maticzpl/Documents/calf/default-connected";
    };
    nld.enable = true;
    fish = {
      enable = true;
      username = "maticzpl";
    };
    remoteDisplay = {
      enable = false;
      username = "maticzpl";
    };
    hyprland = {
      enable = true;
      username = "maticzpl";
      wallpaper = "~/Pictures/wallpapers/2022-01-08-00-03-18.png";
      hyprlock = {
        mainMonitor = "eDP-1";
      };
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-fc2d8366-c40b-468c-8c00-ab4797aee9ba".device = "/dev/disk/by-uuid/fc2d8366-c40b-468c-8c00-ab4797aee9ba";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        libvdpau-va-gl
      ];
  };

  networking.hostName = "mati-nixos-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = false;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  services.desktopManager.plasma6.enable = false;

  # Configure keymap in X11
  services.xserver = {
    xkb = { 
        variant = "";
        layout = "pl";
    };
  };

  services.flatpak.enable = true;

  # Configure console keymap
  console.keyMap = "pl2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.maticzpl = {
    isNormalUser = true;
    description = "Maticzpl";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git

    neovim
    fd
    ripgrep
    nixd

    rustup
    gcc
    tree
    xclip
    wl-clipboard
    unzip
    nodejs

    # gsettings-desktop-schemas
    adwaita-icon-theme
    gtk3
    glib
  ];

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.xremap = {
      serviceMode = "user";
      userName = "maticzpl";
      config.keymap = [];
      #deviceNames = [ ];
  };

  powerManagement = {
      enable = true;
      powertop.enable = true;
  };
  # programs.dconf.enable = true;
  # xdg.portal = {
  #     enable = true;
  #     extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  # };
  # environment.variables.XDG_DATA_DIRS = [ "${pkgs.spotify}/share/gsettings-schemas/${pkgs.spotify.name}" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}