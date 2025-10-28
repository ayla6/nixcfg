{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  flakeInputs = lib.filterAttrs (name: value: (lib.isType "flake" value) && (name != "self")) inputs;
in {
  options.myNixOS.programs.nix.enable = lib.mkEnableOption "sane nix configuration";

  config = lib.mkIf config.myNixOS.programs.nix.enable {
    nix = {
      package = pkgs.nixVersions.latest;

      gc = {
        automatic = true;

        options = "--delete-older-than 3d";

        persistent = true;
        randomizedDelaySec = "60min";
      };

      optimise = {
        automatic = true;
        persistent = true;
        randomizedDelaySec = "60min";
      };

      # https://github.com/isabelroses/dotfiles/blob/main/modules/base/nix/nix.nix#L34-L38
      # pin the registry to avoid downloading and evaluating a new nixpkgs version everytime
      registry =
        (lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs)
        // {
          # https://github.com/NixOS/nixpkgs/pull/388090
          nixpkgs = lib.mkForce {flake = inputs.nixpkgs;};
        };

      inherit (config.mySnippets.nix) settings;
    };
  };
}
