_: {
  perSystem = _: {
    pre-commit.settings.hooks = {
      alejandra.enable = true;
      deadnix.enable = true;
      prettier.enable = false;
      shellcheck.enable = true;

      shfmt = {
        enable = true;
        args = ["-i" "2"];
      };

      statix.enable = true;
    };
  };
}
