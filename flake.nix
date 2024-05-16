{
  description = "Maticzpl's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      modules = [ 
        ./configuration.nix
      ];
    };
  };
}
