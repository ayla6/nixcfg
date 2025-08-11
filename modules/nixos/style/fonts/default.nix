{
  pkgs,
  lib,
  config,
  ...
}: let
  emojiFont = "Noto Color Emoji";
in {
  options.myNixOS.style.fonts = {
    enable = lib.mkEnableOption "enable fonts";
  };

  config = lib.mkIf config.myNixOS.style.fonts.enable {
    environment.variables = {
      FREETYPE_PROPERTIES = "autofitter:no-stem-darkening=0 autofitter:darkening-parameters=500,0,1000,500,2500,500,4000,0 cff:no-stem-darkening=0 type1:no-stem-darkening=0 t1cid:no-stem-darkening=0";
      QT_NO_SYNTHESIZED_BOLD = 1;
    };
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      noto-fonts-color-emoji
      roboto-flex
      roboto
      nerd-fonts.jetbrains-mono
      jetbrains-mono
      source-code-pro
      liberation_ttf
    ];

    fonts.fontconfig = {
      enable = true;
      includeUserConf = false;
      defaultFonts = {
        serif = [
          "Noto Serif"
          "NotoSerifCJK"
          "Noto Serif CJK JP"
        ];
        sansSerif = [
          "Roboto Flex"
          "Roboto"
          "Noto Sans"
          "NotoSansCJK"
          "Noto Sans CJK JP"
        ];
        monospace = [
          "JetBrains Mono NL"
          "Source Code Pro"
          "Noto Sans CJK JP"
        ];
      };
      useEmbeddedBitmaps = true;
      subpixel = {
        lcdfilter = "none";
        rgba = "none";
      };
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
        autohint = false;
      };
      localConf = ''
        <?xml version="1.0"?>
        <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
        <fontconfig>
          <match target="pattern">
            <test qual="any" name="family"><string>emoji</string></test>
            <edit name="family" mode="assign" binding="same"><string>${emojiFont}</string></edit>
          </match>
          <match target="pattern">
            <test name="family"><string>sans</string></test>
            <edit name="family" mode="append"><string>${emojiFont}</string></edit>
          </match>
          <match target="pattern">
            <test name="family"><string>serif</string></test>
            <edit name="family" mode="append"><string>${emojiFont}</string></edit>
          </match>
          <match target="pattern">
            <test name="family"><string>sans-serif</string></test>
            <edit name="family" mode="append"><string>${emojiFont}</string></edit>
          </match>
          <match target="pattern">
            <test name="family"><string>monospace</string></test>
            <edit name="family" mode="append"><string>${emojiFont}</string></edit>
          </match>
          <match target="pattern">
            <test name="family"><string>system-ui</string></test>
            <edit name="family" mode="append"><string>${emojiFont}</string></edit>
          </match>

          <match target="font">
            <test name="family"><string>Calibri</string></test>
            <edit name="embeddedbitmap" mode="assign"><bool>false</bool></edit>
          </match>
          <match target="font">
            <test name="family"><string>Cambria</string></test>
            <edit name="embeddedbitmap" mode="assign"><bool>false</bool></edit>
          </match>

          <selectfont>
            <rejectfont>
              <pattern><patelt name="family"><string>Droid Sans Fallback</string></patelt></pattern>
              <pattern><patelt name="family"><string>Droid Sans Japanese</string></patelt></pattern>
            </rejectfont>
          </selectfont>
        </fontconfig>
      '';
    };
  };
}
