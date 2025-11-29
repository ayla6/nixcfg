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
          bright0 = "525561"; # black
          bright1 = "673a3c"; # red
          bright2 = "4d6140"; # green
          bright3 = "e5c07b"; # yellow
          bright4 = "385378"; # blue
          bright5 = "d6b4e4"; # magenta
          bright6 = "3a565b"; # cyan
          bright7 = "fafafa"; # white
          dim0 = "dce0e5"; # black
          dim1 = "eab7b9"; # red
          dim2 = "d1e0bf"; # green
          dim3 = "f1dfc1"; # yellow
          dim4 = "bed5f4"; # blue
          dim5 = "612a79"; # magenta
          dim6 = "b9d9df"; # cyan
          dim7 = "575d65"; # white
        };
      };
    };
  };
}
