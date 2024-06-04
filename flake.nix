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

    outputs = { self, nixpkgs, nix-ld, ... }@inputs: {
        nixosConfigurations.default = nixpkgs.lib.nixosSystem {
            specialArgs = {inherit inputs;};
            modules = [ 
                nix-ld.nixosModules.nix-ld
                ./hosts/default/configuration.nix
                ./nix-modules
                inputs.home-manager.nixosModules.default
            ];
        };

        homeManagerModules.default = "./home-manager-modules";
    };
}
