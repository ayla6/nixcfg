{
  lib,
  config,
  ...
}: {
  options.myHome.programs.jujutsu.enable = lib.mkEnableOption "jujutsu version control";

  config = lib.mkIf config.myHome.programs.jujutsu.enable {
    programs.jjui = {
      enable = true;
      settings = {
        keys = {
          up = ["up" "i"];
          down = ["down" "e"];
          jump_to_parent = ["E"];
          jump_to_children = ["I"];
          edit = ["h"];
          diffedit = ["H"];
          rebase.insert = ["l"];
          revert = {
            insert = ["l"];
            skip_empied = ["e"];
          };
          squash = {
            interactive = ["l"];
            keep_emptied = ["e"];
          };
        };
        ui.colors.selected.bg = "#808080";
      };
    };
    programs.jujutsu = {
      enable = true;
      settings = {
        inherit (config.mySnippets.git) user;
        git = {
          fetch = ["origin" "upstream"];
        };
        signing = {
          behavior = "own";
          backend = "ssh";
          key = "~/.ssh/id_ed25519.pub";
        };
        ui = {
          diff-editor = ":builtin";
        };
        #merge-tools.meld.program = lib.getExe pkgs.meld;
      };
    };
  };
}
