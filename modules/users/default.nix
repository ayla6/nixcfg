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
        # right now this config is fine but if i ever get another machine i daily drive or a build server i need to do something else here
        (lib.filter (file:
          if config.networking.hostName == "morgana"
          then "ayla_m23.pub" == file
          else (lib.elem file ["ayla_morgana.pub" "ayla_23.pub"]))
        (builtins.attrNames (builtins.readDir "${self.inputs.secrets}/publicKeys")));
    };
  };
}
