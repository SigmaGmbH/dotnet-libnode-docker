{
  description = "Docker image build for https://github.com/microsoft/node-api-dotnet";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }: let
    # System types to support.
    supportedSystems = [ "x86_64-linux" ];
  in flake-utils.lib.eachSystem supportedSystems (system: let
    pkgs = nixpkgs.legacyPackages.${system};
    inherit (pkgs) lib;

    libnode = pkgs.callPackage ./libnode.nix { };
    # Usage:
    # nix build .#libnode-docker
    # docker load < result
    # docker run ...
    libnode-docker = pkgs.dockerTools.buildLayeredImage {
      name = "libnode-docker";
      tag = "latest";
      contents = [ libnode ];
      maxLayers = 120;
    };
    derivation = {
      inherit libnode-docker libnode;
      default = libnode;
    };
  in {
    packages = derivation;
  });
}