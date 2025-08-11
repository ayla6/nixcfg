{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./ayla
    ./options.nix
  ];

  config = lib.mkIf (config.myUsers.root.enable or config.myUsers.ayla) {
    programs.fish.enable = true;

    users = {
      defaultUserShell = pkgs.fish;
      mutableUsers = false;
    };
  };
}
