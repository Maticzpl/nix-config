{
    description = "Maticzpl's flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
        nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.05";
        nixpkgs-very-fucking-unstable.url = "github:nixos/nixpkgs?ref=master"; # Too impatient to wait for changes from master to be merged to unstable lol

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-ld = {
            url = "github:Mic92/nix-ld";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
        hyprland-plugins = {
          url = "github:hyprwm/hyprland-plugins";
          inputs.hyprland.follows = "hyprland";
        };

        xremap-flake = {
          url = "github:xremap/nix-flake";
        };

        ags = {
          url = "github:Aylur/ags";
        };

        anyrun = {
            url = "github:anyrun-org/anyrun";
            inputs.nixpkgs.follows = "nixpkgs";
        };

    };

    outputs = { self, nixpkgs, nix-ld, home-manager, ... }@inputs: {
        nixosConfigurations.default = nixpkgs.lib.nixosSystem {
            specialArgs = {
                inherit inputs;
            };
            modules = [ 
                # nix-ld.nixosModules.nix-ld
                ./hosts/default/configuration.nix
                ./nix-modules
                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.users.maticzpl = import ./hosts/default/home.nix;
                    home-manager.extraSpecialArgs = { inherit inputs; };
                }
                inputs.xremap-flake.nixosModules.default
            ];
        };

        nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
            specialArgs = {inherit inputs;};
            modules = [
                ./hosts/laptop/configuration.nix
                ./nix-modules
                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.users.maticzpl = import ./hosts/laptop/home.nix;
                    home-manager.extraSpecialArgs = { inherit inputs; };
                }
                inputs.xremap-flake.nixosModules.default
            ];
        };

    };
}
