{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./gnome
    ./plasma
    ./cosmic
    ./niri
  ];

  options.myNixOS.desktop.enable = lib.mkOption {
    default =
      config.myNixOS.desktop.gnome.enable or config.myNixOS.desktop.hyprland.enable
          or config.myNixOS.desktop.kde.enable;
    description = "Desktop environment configuration.";
    type = lib.types.bool;
  };

  config = lib.mkIf config.myNixOS.desktop.enable {
    boot = {
      consoleLogLevel = 0;
      initrd.verbose = false;
      plymouth.enable = true;
    };

    environment = {
      sessionVariables.NIXOS_OZONE_WL = "1";

      # stem darkening for prettier fonts
      variables = {
        FREETYPE_PROPERTIES = "autofitter:no-stem-darkening=0 autofitter:darkening-parameters=500,0,1000,500,2500,500,4000,0 cff:no-stem-darkening=0 type1:no-stem-darkening=0 t1cid:no-stem-darkening=0";
        QT_NO_SYNTHESIZED_BOLD = 1;
      };
    };

    # other font settings
    fonts = {
      fontconfig = {
        enable = true;
        includeUserConf = true;
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

        # have i told you how much i despise fontconfig. literally zero reason to pick bitmap fonts over noto fonts but it always does.
        #localConf = ''
        #  <?xml version="1.0"?>
        #  <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
        #  <fontconfig>
        #    <description>Reject bitmap fonts except bitmap emoji fonts</description>
        #    <selectfont>
        #      <rejectfont>
        #        <pattern>
        #          <patelt name="outline"><bool>false</bool></patelt>
        #          <patelt name="scalable"><bool>false</bool></patelt>
        #        </pattern>
        #      </rejectfont>
        #    </selectfont>
        #  </fontconfig>
        #'';
      };

      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
      ];
    };

    home-manager.sharedModules = [
      {
        config.myHome.desktop.enable = true;
      }
    ];

    programs.xwayland.enable = true;

    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;

        publish = {
          enable = true;
          addresses = true;
          userServices = true;
          workstation = true;
        };
      };

      gnome.gnome-keyring.enable = true;
      gvfs.enable = true; # Mount, trash, etc.
      libinput.enable = true;

      pipewire = {
        enable = true;

        alsa = {
          enable = true;
          support32Bit = true;
        };

        pulse.enable = true;
      };

      pulseaudio = {
        support32Bit = true;
      };

      geoclue2 = {
        enable = true;
      };
    };

    system.nixos.tags = ["desktop"];
  };
}
