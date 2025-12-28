{
  pkgs,
  lib,
  config,
  ...
}: {
  options.myNixOS.services.kanata.enable = lib.mkEnableOption "kanata";

  config = lib.mkIf config.myNixOS.services.kanata.enable {
    hardware.uinput.enable = true;
    users.groups.uinput.members = ["ayla" "root"];

    services.kanata = {
      enable = true;
      keyboards.internalKeyboard = {
        config = builtins.readFile ./layout.lisp;
        extraDefCfg = "process-unmapped-keys yes";
        devices = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd" "/dev/input/by-id/usb-Logitech_Logitech_USB_Keyboard-event-kbd" "/dev/input/by-id/usb-Logitech_Logitech_USB_Keyboard-hidraw"];
      };
    };

    environment.sessionVariables.XKB_DEFAULT_LAYOUT = "us_for_kanata";

    services.xserver.xkb = {
      layout = lib.mkForce "us_for_kanata";
      variant = lib.mkForce "";
      extraLayouts.us_for_kanata = {
        description = "us for kanata";
        languages = ["eng"];
        symbolsFile =
          pkgs.writeText "us_for_kanata"
          ''
            xkb_symbols "us_for_kanata"
            {
            name[Group1]= "us for kanata";

            key <TLDE>	{[   grave,	 asciitilde	]};
            key <AE01>	{[	 1,	 exclam		]};
            key <AE02>	{[	 2,	 at		]};
            key <AE03>	{[	 3,	 numbersign	]};
            key <AE04>	{[	 4,	 dollar		]};
            key <AE05>	{[	 5,	 percent	]};
            key <AE06>	{[	 6,	 asciicircum	]};
            key <AE07>	{[	 7,	 ampersand	]};
            key <AE08>	{[	 8,	 asterisk	]};
            key <AE09>	{[	 9,	 parenleft	]};
            key <AE10>	{[	 0,	 parenright	]};
            key <AE11>	{[   minus,	 underscore, emdash, endash ]};
            key <AE12>	{[   equal,	 plus		]};

            key <AD01>	{[	 q,	 Q, atilde, Atilde		]};
            key <AD02>	{[	 w,	 W		]};
            key <AD03>	{[	 e,	 E, eacute, Eacute		]};
            key <AD04>	{[	 r,	 R, atilde, Atilde		]};
            key <AD05>	{[	 t,	 T		]};
            key <AD06>	{[	 y,	 Y		]};
            key <AD07>	{[	 u,	 U, uacute, Uacute		]};
            key <AD08>	{[	 i,	 I, iacute, Iacute		]};
            key <AD09>	{[	 o,	 O, oacute, Oacute		]};
            key <AD10>	{[	 p,	 P		]};
            key <AD11>	{[ bracketleft,	 braceleft	]};
            key <AD12>	{[ bracketright, braceright	]};

            key <AC01>	{[	 a,	 A,  aacute, Aacute		]};
            key <AC02>	{[	 s,	 S,  agrave, Agrave		]};
            key <AC03>	{[	 d,	 D		]};
            key <AC04>	{[	 f,	 F		]};
            key <AC05>	{[	 g,	 G		]};
            key <AC06>	{[	 h,	 H		]};
            key <AC07>	{[	 j,	 J		]};
            key <AC08>	{[	 k,	 K		]};
            key <AC09>	{[	 l,	 L		]};
            key <AC10>	{[ semicolon,	 colon, otilde, Otilde		]};
            key <AC11>	{[ apostrophe,	 quotedbl	]};
            key <BKSL>	{[ backslash,	 bar		]};

            key <AB01>	{[	 z,	 Z		]};
            key <AB02>	{[	 x,	 X		]};
            key <AB03>	{[	 c,	 C,  ccedilla,  Ccedilla		]};
            key <AB04>	{[	 v,	 V		]};
            key <AB05>	{[	 b,	 B		]};
            key <AB06>	{[	 n,	 N		]};
            key <AB07>	{[	 m,	 M		]};
            key <AB08>	{[   comma,	 less		]};
            key <AB09>	{[  period,	 greater,  ellipsis	]};
            key <AB10>	{[   slash,	 question	]};

            include "level3(ralt_switch)"
            };
          '';
      };
    };
  };
}
