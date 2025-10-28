# https://github.com/isabelroses/dotfiles/blob/main/modules/base/nix/nix.nix
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

          # Allows Nix to automatically pick UIDs for builds, rather than creating nixbld* user accounts
          # which is BEYOND annoying, which makes this a really nice feature to have
          "auto-allocate-uids"

          # allows Nix to execute builds inside cgroups
          # remember you must also enable use-cgroups in the nix.conf or settings
          "cgroups"

          # enable the use of the fetchClosure built-in function in the Nix language.
          "fetch-closure"
        ];

        substituters = [
          "https://cache.nixos.org/"
        ];

        trusted-public-keys = [
        ];

        trusted-users = ["@admin" "@wheel" "nixbuild"];

        # Free up to 20GiB whenever there is less than 5GB left.
        # this setting is in bytes, so we multiply with 1024 by 3
        min-free = 5 * 1024 * 1024 * 1024;
        max-free = 20 * 1024 * 1024 * 1024;

        # automatically optimise symlinks
        # Disable auto-optimise-store because of this issue:
        # https://github.com/NixOS/nix/issues/7273
        # but we use lix which has a fix for this issue:
        # https://gerrit.lix.systems/c/lix/+/2100
        auto-optimise-store = true;

        # we don't want to track the registry, but we do want to allow the usage
        # of the `flake:` references, so we need to enable use-registries
        use-registries = true;
        flake-registry = "";

        # let the system decide the number of max jobs
        max-jobs = "auto";

        # this defaults to true, however it slows down evaluation so maybe we should disable it
        # some day, but we do need it for catppuccin/nix so maybe not too soon
        allow-import-from-derivation = true;

        # for direnv GC roots
        keep-derivations = true;
        keep-outputs = true;

        # use xdg base directories for all the nix things
        use-xdg-base-directories = true;
        # don't warn me if the current working tree is dirty
        # i don't need the warning because i'm working on it right now
        warn-dirty = false;

        # maximum number of parallel TCP connections used to fetch imports and binary caches, 0 means no limit
        http-connections = 50;

        # whether to accept nix configuration from a flake without prompting
        # littrally a CVE waiting to happen <https://x.com/puckipedia/status/1693927716326703441>
        accept-flake-config = false;
      };
    };
  };
}
