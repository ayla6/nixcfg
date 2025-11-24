{pkgs, ...}: {
  services.xserver.xkb.extraLayouts.colemak_dh_wide_ayla = {
    description = "Colemak DH Wide Ayla";
    languages = ["eng"];
    symbolsFile =
      pkgs.writeText "colemak_dh_wide_ayla"
      ''
        xkb_symbols "colemak_dh_wide_ayla"
        {
        name[Group1]= "colemak dh wide ayla";
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

  services.xserver.xkb.extraLayouts.colemak_dh_ayla = {
    description = "Colemak DH Ayla";
    languages = ["eng"];
    symbolsFile =
      pkgs.writeText "colemak_dh_ayla"
      ''
        xkb_symbols "colemak_dh_ayla"
        {
        name[Group1]= "colemak dh ayla";
        include "us(colemak_dh)"

        key <AB05> { [ backslash,  bar,       asciitilde,     brokenbar ] };

        key <AB09> { [ period,     greater,  ellipsis,       dead_abovedot ] };

        key <BKSL> { [ Escape ] };

        key <CAPS> { [ BackSpace ] };
        };
      '';
  };
}
