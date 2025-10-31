{
  pkgs,
  lib,
  config,
  ...
}: {
  options.myNixOS.desktop.gnome.enable = lib.mkEnableOption "use gnome desktop environment";

  config = lib.mkIf config.myNixOS.desktop.gnome.enable {
    home-manager.sharedModules = [
      {
        config.myHome.desktop.gnome.enable = true;
      }
    ];

    services.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      decibels
      epiphany
      geary # email reader
      gedit # text editor
      gnome-console # in case im using something else
      gnome-music
      gnome-software # i like the idea but i really hate how much resources it uses
      gnome-tour
      gnome-user-docs
      simple-scan
    ];

    i18n.inputMethod.type = "ibus";

    security.pam.services.greetd.enableGnomeKeyring = true;
    services.gnome = {
      gcr-ssh-agent.enable = true;
      gnome-remote-desktop.enable = lib.mkForce false;
    };

    programs = {
      kdeconnect = {
        enable = lib.mkDefault true;
        package = lib.mkDefault pkgs.gnomeExtensions.gsconnect;
      };
    };

    environment = {
      variables.QT_QPA_PLATFORMTHEME = "qt6ct";
      systemPackages = with pkgs; [
        libsForQt5.qt5ct
        qt6Packages.qt6ct
      ];
    };

    myNixOS.desktop.enable = true;
    system.nixos.tags = ["gnome"];

    #qt = {
    #  enable = true;
    #  platformTheme = "gnome";
    #  style = "adwaita";
    #};
  };
}
