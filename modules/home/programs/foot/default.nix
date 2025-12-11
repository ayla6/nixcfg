{
  lib,
  config,
  ...
}: let
  inherit (config.mySnippets) fonts;
  colours = config.myHome.profiles.coloursNoHash;
in {
  options.myHome.programs.foot.enable = lib.mkEnableOption "foot terminal";

  config = lib.mkIf config.myHome.programs.foot.enable {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          term = "xterm-256color";
          font = "${fonts.pixel.name}:size=${toString fonts.size.app}, ${fonts.emoji.name}:size=${toString fonts.size.app}";
          initial-window-size-chars = "100x30";
          bold-text-in-bright = "no";
        };

        url = {
          label-letters = "sraneiovkgmfuwy";
        };

        csd = with colours; {
          border-width = 1;
          border-color = accent;
          color = background;
          button-color = foreground;
        };

        colors = with colours;
          {
            cursor = "${foreground} ${foreground}";

            inherit
              foreground
              background
              ;

            inherit
              regular0
              regular1
              regular2
              regular3
              regular4
              regular5
              regular6
              regular7
              ;

            inherit
              bright0
              bright1
              bright2
              bright3
              bright4
              bright5
              bright6
              bright7
              ;
          }
          // (
            if (dim0 != "")
            then {
              inherit
                dim0
                dim1
                dim2
                dim3
                dim4
                dim5
                dim6
                dim7
                ;
            }
            else {}
          );
      };
    };
  };
}
