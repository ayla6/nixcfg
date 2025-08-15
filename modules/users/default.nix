{
  lib,
  config,
  pkgs,
  self,
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

      users.root.openssh.authorizedKeys.keyFiles =
        lib.map (file: "${self.inputs.secrets}/publicKeys/${file}")
        (lib.filter (file: (lib.hasPrefix "ayla_" file) || (lib.hasPrefix "root_morgana" file))
          (builtins.attrNames (builtins.readDir "${self.inputs.secrets}/publicKeys")));
    };
  };
}
