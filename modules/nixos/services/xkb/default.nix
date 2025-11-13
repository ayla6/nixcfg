{pkgs, ...}: let
  layoutName = "colemak_ayla";
in {
  services.xserver.xkb.extraLayouts.${layoutName} = {
    description = "Colemak Ayla";
    languages = ["eng"];
    symbolsFile =
      pkgs.writeText layoutName
      ''
        xkb_symbols "${layoutName}"
        {
        name[Group1]= "colemak ayla";
        include "us(colemak_dh_wide)"

        key <AB02> { [ d,          D,        dead_diaeresis, asciitilde ] };
        key <AB03> { [ c,          C,        ccedilla,       Ccedilla ] };
        key <AB05> { [ Escape ] };
        key <AB06> { [ backslash, bar,       asciitilde,     brokenbar ] };

        key <AB10> { [ period,     greater,  ellipsis,       dead_abovedot ] };

        key <BKSL> { [ apostrophe, quotedbl, otilde,         Otilde ] };
        key <AD12> { [ slash,      question, questiondown,   asciitilde ] };

        key <CAPS> { [ BackSpace ] };
        };
      '';
  };
}
