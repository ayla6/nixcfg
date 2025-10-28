{
  lib,
  config,
  ...
}: {
  options.myHome.programs.jujutsu.enable = lib.mkEnableOption "jujutsu version control";

  config = lib.mkIf config.myHome.programs.jujutsu.enable {
    programs.jjui = {
      enable = true;
    };
    programs.jujutsu = {
      enable = true;
      settings = {
        inherit (config.mySnippets.git) user;
        signing = {
          behavior = "own";
          backend = "ssh";
          key = "~/.ssh/id_ed25519.pub";
        };
      };
    };
  };
}
