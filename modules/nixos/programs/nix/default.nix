{
  config,
  lib,
  pkgs,
  ...
}: {
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

      inherit (config.mySnippets.nix) settings;
    };
  };
}
