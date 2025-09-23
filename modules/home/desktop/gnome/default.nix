{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.desktop.gnome = {
    enable = lib.mkEnableOption "GNOME desktop environment";
  };

  config = lib.mkIf config.myHome.desktop.gnome.enable {
    dconf = {
      enable = true;

      settings = let
        defaultApps = {
          terminal = config.myHome.profiles.defaultApps.terminal.exec or (lib.getExe pkgs.gnome-console);
          webBrowser =
            config.myHome.profiles.defaultApps.webBrowser.exec
                or (lib.getExe config.programs.firefox.finalPackage);
          fileManager = config.myHome.profiles.defaultApps.fileManager.exec or (lib.getExe pkgs.nautilus);
          editor = config.myHome.profiles.defaultApps.editor.exec or (lib.getExe pkgs.gnome-text-editor);
          archiveViewer = config.myHome.profiles.defaultApps.archiveViewer.exec or (lib.getExe pkgs.file-roller);
        };
      in {
        "org/gnome/desktop/datetime".automatic-timezone = true;

        "org/gnome/desktop/interface" = {
          clock-format = "24h";
          enable-hot-corners = false;
        };

        "org/gnome/desktop/peripherals/touchpad".tap-to-click = true;
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Super>Return";
          command = "${defaultApps.terminal}${lib.optionalString (config.myHome.profiles.defaultApps.terminal.package == pkgs.ptyxis) " --new-window"}";
          name = "Terminal";
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          binding = "<Super>e";
          command = "${defaultApps.fileManager}";
          name = "File Manager";
        };

        "org/gnome/shell" = {
          welcome-dialog-last-shown-version = "9999999999"; # No welcome dialog.
        };

        "org/gnome/shell/keybindings" = {
          switch-to-application-1 = [];
          switch-to-application-2 = [];
          switch-to-application-3 = [];
          switch-to-application-4 = [];
          switch-to-application-5 = [];
          switch-to-application-6 = [];
          switch-to-application-7 = [];
          switch-to-application-8 = [];
          switch-to-application-9 = [];
          switch-to-application-10 = [];
        };

        "org/gnome/system/location".enabled = false;

        "org/gnome/desktop/wm/keybindings" = {
          move-to-monitor-down = ["<Ctrl><Shift><Super>Down"];
          move-to-monitor-left = ["<Ctrl><Shift><Super>Left"];
          move-to-monitor-right = ["<Ctrl><Shift><Super>Right"];
          move-to-monitor-up = ["<Ctrl><Shift><Super>Up"];
          move-to-workspace-1 = ["<Shift><Super>1"];
          move-to-workspace-10 = ["<Shift><Super>0"];
          move-to-workspace-2 = ["<Shift><Super>2"];
          move-to-workspace-3 = ["<Shift><Super>3"];
          move-to-workspace-4 = ["<Shift><Super>4"];
          move-to-workspace-5 = ["<Shift><Super>5"];
          move-to-workspace-6 = ["<Shift><Super>6"];
          move-to-workspace-7 = ["<Shift><Super>7"];
          move-to-workspace-8 = ["<Shift><Super>8"];
          move-to-workspace-9 = ["<Shift><Super>9"];
          switch-to-workspace-1 = ["<Super>1"];
          switch-to-workspace-10 = ["<Super>0"];
          switch-to-workspace-2 = ["<Super>2"];
          switch-to-workspace-3 = ["<Super>3"];
          switch-to-workspace-4 = ["<Super>4"];
          switch-to-workspace-5 = ["<Super>5"];
          switch-to-workspace-6 = ["<Super>6"];
          switch-to-workspace-7 = ["<Super>7"];
          switch-to-workspace-8 = ["<Super>8"];
          switch-to-workspace-9 = ["<Super>9"];
          switch-to-workspace-down = [];
          switch-to-workspace-left = ["<Ctrl><Super>Left"];
          switch-to-workspace-right = ["<Ctrl><Super>Right"];
          switch-to-workspace-up = [];
          toggle-fullscreen = ["<Super>w"];
        };
      };
    };

    programs = {
      firefox.nativeMessagingHosts = [pkgs.gnome-browser-connector];

      gnome-shell = {
        enable = true;

        extensions = [
          {package = pkgs.gnomeExtensions.appindicator;}
          {package = pkgs.gnomeExtensions.night-theme-switcher;}
          {package = pkgs.gnomeExtensions.gsconnect;}
          {package = pkgs.gnomeExtensions.just-perfection;}
          {package = pkgs.gnomeExtensions.caffeine;}
        ];
      };
    };

    home.packages = with pkgs; [
      gnome-tweaks
      adw-gtk3
      gnome-extension-manager
      morewaita-icon-theme
    ];

    myHome.profiles.defaultApps = {
      audioPlayer.package = lib.mkDefault pkgs.mpv;
      editor.package = lib.mkDefault pkgs.gnome-text-editor;
      fileManager.package = lib.mkDefault pkgs.nautilus;
      imageViewer.package = lib.mkDefault pkgs.loupe;
      pdfViewer.package = lib.mkDefault pkgs.papers;
      terminal.package = lib.mkDefault pkgs.gnome-console;
      videoPlayer.package = lib.mkDefault pkgs.mpv;
    };
  };
}
