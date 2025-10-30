{
  lib,
  config,
  pkgs,
  ...
}: {
  options.myHome.desktop.cosmic = {
    enable = lib.mkEnableOption "COSMIC desktop environment";
  };

  config = lib.mkIf config.myHome.desktop.cosmic.enable {
    dconf = {
      enable = true;

      settings = {
        "org/gnome/desktop/wm/preferences".button-layout = "appmenu:close";
      };
    };

    myHome.profiles.defaultApps = {
      audioPlayer = {
        package = lib.mkDefault config.programs.mpv.finalPackage;
        icon = lib.mkDefault "mpv";
      };
      editor = {
        package = lib.mkDefault pkgs.cosmic-edit;
        icon = lib.mkDefault "com.system76.CosmicEdit";
      };
      fileManager = {
        package = lib.mkDefault pkgs.cosmic-files;
        icon = lib.mkDefault "com.system76.CosmicFiles";
      };
      imageViewer = {
        package = lib.mkDefault pkgs.loupe;
        icon = lib.mkDefault "org.gnome.Loupe";
      };
      pdfViewer = {
        package = lib.mkDefault pkgs.papers;
        icon = lib.mkDefault "org.gnome.Papers";
      };
      terminal = {
        package = lib.mkDefault pkgs.cosmic-term;
        icon = lib.mkDefault "com.system76.CosmicTerm";
      };
      videoPlayer = {
        package = lib.mkDefault config.programs.mpv.finalPackage;
        icon = lib.mkDefault "mpv";
      };
    };
  };
}
