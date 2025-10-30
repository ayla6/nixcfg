{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./gnome
    ./plasma
    ./cosmic
  ];

  options.myHome.desktop.enable = lib.mkOption {
    default = config.myHome.desktop.gnome.enable or config.myHome.desktop.plasma.enable;
    description = "Desktop environment configuration.";
    type = lib.types.bool;
  };

  config = lib.mkIf config.myHome.desktop.enable {
    home.packages = [
      pkgs.adwaita-icon-theme
    ];

    dconf = {
      enable = true;

      settings = {
        "org/gnome/nm-applet".disable-connected-notifications = true;
        "org/gtk/gtk4/settings/file-chooser".sort-directories-first = true;
        "org/gtk/settings/file-chooser".sort-directories-first = true;
      };
    };

    gtk.gtk3.bookmarks = [
      "file://${config.xdg.userDirs.documents}"
      "file://${config.xdg.userDirs.download}"
      "file://${config.xdg.userDirs.music}"
      "file://${config.xdg.userDirs.videos}"
      "file://${config.xdg.userDirs.pictures}"
    ];

    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      desktop = lib.mkDefault "${config.home.homeDirectory}/Desktop";
      documents = lib.mkDefault "${config.home.homeDirectory}/Documents";
      download = lib.mkDefault "${config.home.homeDirectory}/Downloads";
      music = lib.mkDefault "${config.home.homeDirectory}/Music";
      pictures = lib.mkDefault "${config.home.homeDirectory}/Pictures";
      publicShare = lib.mkDefault "${config.home.homeDirectory}/Public";
      templates = lib.mkDefault "${config.home.homeDirectory}/Templates";
      videos = lib.mkDefault "${config.home.homeDirectory}/Videos";
    };
  };
}
