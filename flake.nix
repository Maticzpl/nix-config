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
                /home/maticzpl/nix/hosts/default/configuration.nix
                inputs.home-manager.nixosModules.default
                # { programs.nix-ld.dev.enable = true; }
            ];
        };
    };
}
