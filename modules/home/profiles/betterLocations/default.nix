{
  config,
  lib,
  ...
}: {
  options.myHome.profiles.betterLocations.enable = lib.mkEnableOption "for a slightly less cluttered home folder";

  config = lib.mkIf config.myHome.profiles.betterLocations.enable {
    home.sessionVariables = {
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    };

    programs = {
      bash = {
        enable = true;
        historyFile = "${config.xdg.dataHome}/bash_history";
      };
      gpg = {
        enable = true;
        homedir = "${config.xdg.dataHome}/gnupg";
      };
    };
  };
}
