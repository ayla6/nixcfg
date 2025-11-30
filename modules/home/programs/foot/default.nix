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
          term = "xterm-256color";
          font = "JetBrainsMono Nerd Font:size=10, Noto Color Emoji:size=10";
          initial-window-size-chars = "140x36";
          bold-text-in-bright = "no";
        };

        url = {
          label-letters = "arstneiovkgmfuwy";
        };

        csd = {
          preferred = "client";
          border-width = 1;
          border-color = "b477cf";
          color = "282c33"; # background
          button-color = "c8ccd4"; # font
        };

        colors = {
          cursor = "74ade8 fafafa";
          foreground = "c8ccd4";
          background = "282c33";
          regular0 = "282c33"; # black
          regular1 = "d07277"; # red
          regular2 = "a1c181"; # green
          regular3 = "dfc184"; # yellow
          regular4 = "73ade9"; # blue
          regular5 = "b477cf"; # magenta
          regular6 = "6eb4bf"; # cyan
          regular7 = "dce0e5"; # white
          dim0 = "dce0e5"; # black
          dim1 = "673a3c"; # red
          dim2 = "4d6140"; # green
          dim3 = "e5c07b"; # yellow
          dim4 = "385378"; # blue
          dim5 = "612a79"; # magenta
          dim6 = "3a565b"; # cyan
          dim7 = "575d65"; # white
          bright0 = "525561"; # black
          bright1 = "eab7b9"; # red
          bright2 = "d1e0bf"; # green
          bright3 = "f1dfc1"; # yellow
          bright4 = "bed5f4"; # blue
          bright5 = "d6b4e4"; # magenta
          bright6 = "b9d9df"; # cyan
          bright7 = "fafafa"; # white
        };
      };
    };
  };
}
