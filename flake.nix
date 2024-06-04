{
    description = "Maticzpl's flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-ld = {
            url = "github:Mic92/nix-ld";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { self, nixpkgs, nix-ld, home-manager, ... }@inputs: {
        nixosConfigurations.default = nixpkgs.lib.nixosSystem {
            specialArgs = {inherit inputs;};
            modules = [ 
                nix-ld.nixosModules.nix-ld
                ./hosts/default/configuration.nix
                ./nix-modules
                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.users.maticzpl = import ./hosts/default/home.nix;
                }
            ];
        };

    };
}
