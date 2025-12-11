{
  pkgs,
  lib,
  config,
  ...
}: {
  options.myNixOS.desktop.niri.enable = lib.mkEnableOption "use niri desktop environment";

  config = lib.mkIf config.myNixOS.desktop.niri.enable {
    home-manager.sharedModules = [
      {
        config.myHome.desktop.niri.enable = true;
      }
    ];

    xdg = {
      mime.enable = true;
      icons.enable = true;

      portal = {
        config = {
          common = {
            default = [
              "gtk"
            ];
          };
          niri = {
            default = ["gnome" "gtk"];
            "org.freedesktop.impl.portal.Secret" = [
              "gnome-keyring"
            ];
          };
        };

        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
        ];
      };
    };

    programs.niri.enable = true;

    services.gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = true;
    };
    security.polkit.enable = true;

    environment = {
      variables.QT_QPA_PLATFORMTHEME = "qt6ct";
      systemPackages = with pkgs; [
        libsForQt5.qt5ct
        qt6Packages.qt6ct
      ];
    };

    myNixOS.desktop.enable = true;
    system.nixos.tags = ["niri"];

    #qt = {
    #  enable = true;
    #  platformTheme = "gnome";
    #  style = "adwaita";
    #};
  };
}
