{
  pkgs,
  config,
  ...
}: {
  users.users.ayla = {
    description = "Ayla";
    isNormalUser = true;
    extraGroups = config.myUsers.defaultGroups;
    hashedPassword = config.myUsers.ayla.password;
    uid = 1000;
    shell = pkgs.fish;
  };
}
