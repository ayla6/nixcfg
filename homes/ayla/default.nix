{
  pkgs,
  lib,
  self,
  config,
  ...
}: {
  imports = [
    self.homeModules.default
    self.inputs.nix-flatpak.homeManagerModules.nix-flatpak
    self.inputs.fontix.homeModules.default
  ];

  config = lib.mkMerge [
    {
      home = {
        packages = with pkgs; [
          # development
          ffmpeg-full
          love
          luajit
          nodejs
          pnpm
          typescript

          # applications
          aseprite
          rclone
          rclone-browser
          yt-dlp
        ];

        username = "ayla";
        stateVersion = "25.05";
      };

      programs.home-manager.enable = true;
      xdg.enable = true;

      myHome = {
        desktop = {
          gnome.enable = true;
        };

        programs = {
          chromium.enable = true;
          fastfetch.enable = true;
          firefox = {
            enable = true;
            mode = "sidebar";
          };
          git.enable = true;
          helix.enable = true;
          micro.enable = true;
          mpv.enable = true;
          ssh.enable = true;
          zed-editor.enable = true;
          zen-browser.enable = false;
        };

        profiles = {
          shell.enable = true;
          defaultApps = {
            enable = true;
            forceMimeAssociations = true;
            archiveViewer.package = pkgs.file-roller;
            audioPlayer.package = config.programs.mpv.finalPackage;
            videoPlayer.package = config.programs.mpv.finalPackage;
            editor.package = pkgs.gnome-text-editor;
            fileManager.package = pkgs.nautilus;
            imageViewer.package = pkgs.loupe;
            pdfViewer.package = pkgs.papers;
            #terminal.package = pkgs.ptyxis;
            terminalEditor.package = config.programs.helix.package;
            webBrowser.package = config.programs.firefox.finalPackage;
            #webBrowser = {
            #  exec = lib.getExe config.programs.zen-browser.finalPackage;
            #  package = config.programs.zen-browser.finalPackage;
            #};
          };
        };

        services = {
          aria2.enable = true;
        };
      };

      fontix = {
        fonts = {
          monospace = {
            name = "JetBrainsMono Nerd Font";
            package = pkgs.nerd-fonts.jetbrains-mono;
          };

          sansSerif = {
            name = "Roboto Flex";
            package = pkgs.roboto-flex;
          };

          serif = {
            name = "Source Serif Pro";
            package = pkgs.source-serif-pro;
          };
        };

        sizes = {
          applications = 10;
          desktop = 10;
        };

        font-packages.enable = true;
        fontconfig.enable = true;
        gnome.enable = lib.mkIf pkgs.stdenv.isLinux true;
        gtk.enable = lib.mkIf pkgs.stdenv.isLinux true;
      };

      systemd.user.startServices = true; # Needed for auto-mounting agenix secrets.
    }

    (lib.mkIf pkgs.stdenv.isLinux {
      gtk.gtk3.bookmarks = lib.mkAfter [
        "file:///data/DCIM"
        "file:///data/ Data"
      ];

      home = {
        homeDirectory = "/home/ayla";

        packages = with pkgs; [
          # libraries
          libsecret
          wl-clipboard
          libnotify
          wl-clipboard
          libnotify

          # gaming
          wine
          steam-run
          lutris

          zip
          xz
          unzip
          p7zip
        ];
      };

      services.flatpak = {
        packages = [
          # creative
          "io.lmms.LMMS"
          "org.blender.Blender"
          "org.gimp.GIMP"
          "org.inkscape.Inkscape"
          "org.kde.kdenlive"
          "org.kde.krita"

          # gaming
          "com.github.Anuken.Mindustry"
          "io.mgba.mGBA"
          "net.kuribo64.melonDS"
          "org.openttd.OpenTTD"
          "org.prismlauncher.PrismLauncher"

          # internet
          "org.nicotine_plus.Nicotine"
          "org.qbittorrent.qBittorrent"

          # media
          "com.github.iwalton3.jellyfin-media-player"
          "org.atheme.audacious"
          "org.freac.freac"
          "org.musicbrainz.Picard"
          "org.tenacityaudio.Tenacity"

          # productivity
          "com.calibre_ebook.calibre"
          "md.obsidian.Obsidian"
          "net.ankiweb.Anki"

          # social
          "de.schmidhuberj.Flare"
          "org.gnome.Fractal"

          # utilities
          "com.bitwarden.desktop"
          "com.github.tchx84.Flatseal"
          "org.keepassxc.KeePassXC"
        ];
        update.auto = {
          enable = true;
          onCalendar = "weekly";
        };
      };
    })
  ];
}
