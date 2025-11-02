{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.myHome.profiles.defaultApps;
  mimeTypes = import ./mimeTypes.nix;
in {
  options.myHome.profiles.defaultApps = {
    enable = lib.mkEnableOption "enforce default applications";
    forceMimeAssociations = lib.mkEnableOption "force mime associations for defaultApps";

    archiveViewer = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.nemo;
        description = "The default archive viewer package.";
      };

      exec = lib.mkOption {
        type = lib.types.str;
        default = lib.getExe cfg.archiveViewer.package;
        description = "The executable path for the default archive viewer.";
      };

      icon = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The icon name for the default archive viewer.";
      };
    };

    audioPlayer = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.celluloid;
        description = "The default audio player package.";
      };

      exec = lib.mkOption {
        type = lib.types.str;
        default = lib.getExe cfg.audioPlayer.package;
        description = "The executable path for the default audio player.";
      };

      terminal = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the editor is a terminal-based application.";
      };

      icon = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The icon name for the default audio player.";
      };
    };

    editor = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.gnome-text-editor;
        description = "The default text editor package.";
      };

      exec = lib.mkOption {
        type = lib.types.str;
        default = lib.getExe cfg.editor.package;
        description = "The executable path for the default text editor.";
      };

      terminal = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the editor is a terminal-based application.";
      };

      icon = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The icon name for the default text editor.";
      };
    };

    fileManager = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.nemo;
        description = "The default file manager package.";
      };

      exec = lib.mkOption {
        type = lib.types.str;
        default = lib.getExe cfg.fileManager.package;
        description = "The executable path for the default file manager.";
      };

      terminal = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the editor is a terminal-based application.";
      };

      icon = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The icon name for the default file manager.";
      };
    };

    imageViewer = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.eog;
        description = "The default image viewer package.";
      };

      exec = lib.mkOption {
        type = lib.types.str;
        default = lib.getExe cfg.imageViewer.package;
        description = "The executable path for the default image viewer.";
      };

      icon = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The icon name for the default image viewer.";
      };
    };

    pdfViewer = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.papers;
        description = "The default PDF viewer package.";
      };

      exec = lib.mkOption {
        type = lib.types.str;
        default = lib.getExe cfg.pdfViewer.package;
        description = "The executable path for the default PDF viewer.";
      };

      terminal = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether the editor is a terminal-based application.";
      };

      icon = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The icon name for the default PDF viewer.";
      };
    };

    terminal = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.ghostty;
        description = "The default terminal emulator package.";
      };

      exec = lib.mkOption {
        type = lib.types.str;
        default = lib.getExe cfg.terminal.package;
        description = "The executable path for the default terminal emulator.";
      };

      icon = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The icon name for the default terminal emulator.";
      };
    };

    terminalEditor = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.neovim;
        description = "The default terminal text editor package.";
      };

      exec = lib.mkOption {
        type = lib.types.str;
        default = lib.getExe cfg.terminalEditor.package;
        description = "The executable path for the default terminal text editor.";
      };
    };

    videoPlayer = {
      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.celluloid;
        description = "The default video player package.";
      };

      exec = lib.mkOption {
        type = lib.types.str;
        default = lib.getExe cfg.videoPlayer.package;
        description = "The executable path for the default video player.";
      };

      icon = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The icon name for the default video player.";
      };
    };

    webBrowser = {
      package = lib.mkOption {
        type = lib.types.package;
        default = config.programs.firefox.finalPackage;
        description = "The default web browser package.";
      };

      exec = lib.mkOption {
        type = lib.types.str;
        default = lib.getExe cfg.webBrowser.package;
        description = "The executable path for the default web browser.";
      };

      icon = lib.mkOption {
        type = lib.types.str;
        default = lib.getIcon cfg.webBrowser.package;
        description = "The icon name for the default web browser.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    dconf = {
      enable = true;

      settings = {
        "org/cinnamon/desktop/applications/terminal".exec = "${cfg.terminal.exec}";
        "org/cinnamon/desktop/default-applications/terminal".exec = "${cfg.terminal.exec}";
      };
    };

    home = {
      packages = with cfg; [
        audioPlayer.package
        editor.package
        fileManager.package
        imageViewer.package
        pdfViewer.package
        terminal.package
        terminalEditor.package
        videoPlayer.package
        webBrowser.package
      ];

      sessionVariables = {
        BROWSER = "${builtins.baseNameOf cfg.webBrowser.exec}";
        EDITOR = "${builtins.baseNameOf cfg.terminalEditor.exec}";
        TERMINAL = "${builtins.baseNameOf cfg.terminal.exec}";
      };
    };

    programs.fish.shellInit = ''
      set -gx BROWSER ${builtins.baseNameOf cfg.webBrowser.exec};
      set -gx EDITOR ${builtins.baseNameOf cfg.terminalEditor.exec};
      set -gx TERMINAL ${builtins.baseNameOf cfg.terminal.exec};
    '';

    xdg = {
      configFile = {
        "xfce4/helpers.rc".text = ''
          FileManager=${builtins.baseNameOf cfg.fileManager.exec}
          TerminalEmulator=${builtins.baseNameOf cfg.terminal.exec}
          WebBrowser=${builtins.baseNameOf cfg.webBrowser.exec}
        '';
        "mimeapps.list" = lib.mkIf cfg.forceMimeAssociations {
          force = true;
        };
      };

      mimeApps = lib.mkIf cfg.forceMimeAssociations {
        enable = true;

        defaultApplications = let
          mkDefaults = files: desktopFile: lib.genAttrs files (_: [desktopFile]);
          audioTypes = mkDefaults mimeTypes.audioFiles "defaultAudioPlayer.desktop";

          browserTypes = mkDefaults mimeTypes.browserFiles "defaultWebBrowser.desktop";

          documentTypes = mkDefaults mimeTypes.documentFiles "defaultPdfViewer.desktop";

          editorTypes = mkDefaults mimeTypes.editorFiles "defaultEditor.desktop";

          folderTypes = {
            "inode/directory" = "defaultFileManager.desktop";
          };

          imageTypes = mkDefaults mimeTypes.imageFiles "defaultImageViewer.desktop";

          videoTypes = mkDefaults mimeTypes.videoFiles "defaultVideoPlayer.desktop";

          archiveTypes = mkDefaults mimeTypes.archiveFiles "defaultArchiveViewer.desktop";
        in
          audioTypes
          // browserTypes
          // documentTypes
          // editorTypes
          // folderTypes
          // imageTypes
          // videoTypes
          // archiveTypes;
      };

      desktopEntries = let
        mkDefaultEntry = name: exec: terminal: icon: {
          exec = "${exec} %U";
          icon =
            if icon != ""
            then icon
            else "${builtins.baseNameOf exec}";
          name = "Default ${name}";
          inherit terminal;

          settings = {
            NoDisplay = "true";
          };
        };
      in
        lib.mkIf cfg.forceMimeAssociations {
          defaultAudioPlayer =
            mkDefaultEntry "Audio Player" cfg.audioPlayer.exec cfg.audioPlayer.terminal cfg.audioPlayer.icon;
          defaultEditor =
            mkDefaultEntry "Editor" cfg.editor.exec cfg.editor.terminal cfg.editor.icon;
          defaultFileManager =
            mkDefaultEntry "File Manager" cfg.fileManager.exec cfg.fileManager.terminal cfg.fileManager.icon;
          defaultImageViewer =
            mkDefaultEntry "Image Viewer" cfg.imageViewer.exec false cfg.imageViewer.icon;
          defaultPdfViewer =
            mkDefaultEntry "PDF Viewer" cfg.pdfViewer.exec cfg.pdfViewer.terminal cfg.pdfViewer.icon;
          defaultVideoPlayer =
            mkDefaultEntry "Video Player" cfg.videoPlayer.exec false cfg.videoPlayer.icon;
          defaultWebBrowser =
            mkDefaultEntry "Web Browser" cfg.webBrowser.exec false cfg.webBrowser.icon;
          defaultArchiveViewer =
            mkDefaultEntry "Archive Viewer" cfg.archiveViewer.exec false cfg.archiveViewer.icon;
        };
    };
  };
}
