_: {
  perSystem = {
    config,
    lib,
    pkgs,
    inputs',
    self',
    ...
  }: {
    devShells = {
      morgana =
        pkgs.mkShell {
        };

      default = pkgs.mkShell {
        packages =
          (with pkgs; [
            (lib.hiPrio uutils-coreutils-noprefix)
            git
            nh
          ])
          # ++ lib.attrValues config.treefmt.build.programs
          ++ [
            inputs'.agenix.packages.default
            inputs'.disko.packages.disko-install
            self'.packages.gen-files
          ];

        shellHook = ''
          echo "Installing pre-commit hooks..."
          ${config.pre-commit.installationScript}
          echo "Generating files..."
          ${lib.getExe self'.packages.gen-files}
          export FLAKE="." NH_FLAKE="."
          echo "👋 Welcome to the nixcfg devShell!"
        '';
      };
    };
  };
}
