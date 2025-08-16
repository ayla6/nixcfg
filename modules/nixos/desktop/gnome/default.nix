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

    services = {
      desktopManager.gnome.enable = true;
    };

    environment.gnome.excludePackages = with pkgs; [
      geary # email reader
      gedit # text editor
      gnome-characters
      gnome-music
      gnome-user-docs
      gnome-tour
      decibels
    ];

    i18n.inputMethod.type = "ibus";

    security.pam.services.greetd.enableGnomeKeyring = true;
    services.gnome.gcr-ssh-agent.enable = true;

    programs.kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };

    environment = {
      variables.QT_QPA_PLATFORMTHEME = "qt6ct";
      systemPackages = with pkgs; [
        libsForQt5.qt5ct
        qt6ct
      ];
    };

    myNixOS = {
      desktop.enable = true;
      services.gdm.enable = true;
    };

    #qt = {
    #  enable = true;
    #  platformTheme = "gnome";
    #  style = "adwaita";
    #};
  };
}
