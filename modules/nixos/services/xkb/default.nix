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

        key <AB05> { [ backslash,  bar,       asciitilde,     brokenbar ] };
        key <AB06> { [ slash,      question, questiondown,   asciitilde ] };

        key <AB10> { [ period,     greater,  ellipsis,       dead_abovedot ] };

        key <BKSL> { [ apostrophe, quotedbl, otilde,         Otilde ] };
        key <AD12> { [ Escape ] };

        key <CAPS> { [ BackSpace ] };
        };
      '';
  };
}
