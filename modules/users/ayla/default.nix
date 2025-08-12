{
  pkgs,
  lib,
  config,
  self,
  ...
}: {
  config = lib.mkIf config.myUsers.ayla.enable {
    users.users.ayla = {
      description = "Ayla";
      isNormalUser = true;
      extraGroups = config.myUsers.defaultGroups;
      hashedPassword = config.myUsers.ayla.password;

      openssh.authorizedKeys.keyFiles =
        lib.map (file: "${self.inputs.secrets}/publicKeys/${file}")
        (lib.filter (file: (lib.hasPrefix "ayla_" file) || (lib.hasPrefix "root_morgana" file))
          (builtins.attrNames (builtins.readDir "${self.inputs.secrets}/publicKeys")));

      uid = 1000;
      shell = pkgs.fish;
    };
  };
}
