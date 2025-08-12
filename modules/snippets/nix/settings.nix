{lib, ...}: {
  options = {
    mySnippets.nix.settings = lib.mkOption {
      type = lib.types.attrs;
      description = "Default nix settings shared across machines.";

      default = {
        builders-use-substitutes = true;

        experimental-features = [
          "ca-derivations"
          "fetch-closure"
          "flakes"
          "nix-command"
          "recursive-nix"
        ];

        substituters = [
          "https://cache.nixos.org/"
        ];

        trusted-public-keys = [
        ];

        trusted-users = ["@admin" "@wheel" "nixbuild"];
      };
    };
  };
}
