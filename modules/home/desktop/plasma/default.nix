{
  lib,
  config,
  pkgs,
  ...
}: {
  options.myHome.desktop.plasma = {
    enable = lib.mkEnableOption "KDE Plasma desktop environment";
  };

  config = lib.mkIf config.myHome.desktop.plasma.enable {
    dconf = {
      enable = true;

      settings = {
        "org/gnome/desktop/wm/preferences".button-layout = "appmenu:minimize,maximize,close";
      };
    };

    myHome.profiles.defaultApps = {
      audioPlayer = {
        package = lib.mkDefault config.programs.mpv.finalPackage;
        icon = lib.mkDefault "mpv";
      };
      editor = {
        package = lib.mkDefault pkgs.kdePackages.kate;
        icon = lib.mkDefault "org.kde.kate";
      };
      fileManager = {
        package = lib.mkDefault pkgs.kdePackages.dolphin;
        exec = lib.mkDefault (lib.getExe config.myHome.profiles.defaultApps.fileManager.package);
        icon = lib.mkDefault "org.kde.dolphin";
      };
      imageViewer = {
        package = lib.mkDefault pkgs.kdePackages.gwenview;
        icon = lib.mkDefault "org.kde.gwenview";
      };
      pdfViewer = {
        package = lib.mkDefault pkgs.kdePackages.okular;
        icon = lib.mkDefault "org.kde.okular";
      };
      terminal = {
        package = lib.mkDefault pkgs.kdePackages.konsole;
        icon = lib.mkDefault "org.kde.konsole";
      };
      videoPlayer = {
        package = lib.mkDefault config.programs.mpv.finalPackage;
        icon = lib.mkDefault "mpv";
      };
    };
  };
}
