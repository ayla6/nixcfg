{
  lib,
  config,
  ...
}: {
  options.myHome.programs.foot.enable = lib.mkEnableOption "foot terminal";

  config = lib.mkIf config.myHome.programs.foot.enable {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          font = "JetBrainsMono Nerd Font:size=9, Noto Color Emoji:size=9";
          initial-window-size-chars = "140x36";
        };

        colors = {
          background = "1e1e1e";
          foreground = "ffffff";

          regular0 = "241f31";
          regular1 = "c01c28";
          regular2 = "2ec27e";
          regular3 = "f5c211";
          regular4 = "1e78e4";
          regular5 = "9841bb";
          regular6 = "0ab9dc";
          regular7 = "c0bfbc";

          bright0 = "5e5c64";
          bright1 = "ed333b";
          bright2 = "57e389";
          bright3 = "f8e45c";
          bright4 = "51a1ff";
          bright5 = "c061cb";
          bright6 = "4fd2fd";
          bright7 = "f6f5f4";
        };
      };
    };
  };
}
