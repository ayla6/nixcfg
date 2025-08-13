{
  lib,
  config,
  ...
}: {
  options.myHome.programs.git.enable = lib.mkEnableOption "git version control";

  config = lib.mkIf config.myHome.programs.git.enable {
    programs.git = {
      enable = true;
      userName = "ayla";
      userEmail = "ayla-git.barcode041@silomails.com";
      signing = {
        format = "ssh";
        key = "~/.ssh/id_ed25519";
        signByDefault = true;
      };
      extraConfig = {
        color.ui = true;
        github.user = "ayla6";
        init = {
          defaultBranch = "main";
        };
        push = {
          autoSetupRemote = true;
          default = "current";
        };
      };
    };
  };
}
