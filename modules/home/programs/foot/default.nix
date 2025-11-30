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

        csd = with config.mySnippets.colors; {
          border-width = 1;
          border-color = magenta;
          color = background;
          button-color = foreground;
        };

        colors = with config.mySnippets.colors; {
          cursor = "74ade8 fafafa";
          inherit foreground;
          inherit background;
          inherit regular0;
          inherit regular1;
          inherit regular2;
          inherit regular3;
          inherit regular4;
          inherit regular5;
          inherit regular6;
          inherit regular7;
          inherit dim0;
          inherit dim1;
          inherit dim2;
          inherit dim3;
          inherit dim4;
          inherit dim5;
          inherit dim6;
          inherit dim7;
          inherit bright0;
          inherit bright1;
          inherit bright2;
          inherit bright3;
          inherit bright4;
          inherit bright5;
          inherit bright6;
          inherit bright7;
        };
      };
    };
  };
}
