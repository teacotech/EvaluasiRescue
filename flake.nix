{
  description = "flake for overleaf sync"
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils, ... }: 
    utils.lib.eachDefaultSystem ( system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        packageOverrides = pkgs.callPackage ./python-packages.nix {};
        python = pkgs.python3.override { inherit packageOverrides; };
      in
      rec {
        devShells.${system}.default = pkgs.mkShell {
          packages = [
            (python.withPackages(p: [ p.request ]))
          ];
        };
      }
    );
}
