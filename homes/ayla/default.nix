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
          #nodejs
          bun
          typescript

          # applications
          aseprite
          rclone
          #rclone-browser
          signal-desktop-bin
          bitwarden-desktop
          yt-dlp
          obsidian
          gimp
          kdePackages.kdenlive
          krita
          inkscape
          qbittorrent

          self.inputs.affinity-nix.packages.${pkgs.stdenv.hostPlatform.system}.v3
        ];

        username = "ayla";
        stateVersion = "25.05";
      };

      programs.home-manager.enable = true;

      xdg.enable = true;

      myHome = {
        programs = {
          helium.enable = true;
          fastfetch.enable = true;
          firefox = {
            enable = true;
            mode = "sidebar";
          };
          git.enable = true;
          helix.enable = true;
          jujutsu.enable = true;
          micro.enable = true;
          mpv.enable = true;
          ssh.enable = true;
          zed-editor.enable = true;
        };

        profiles = {
          betterLocations.enable = true;
          shell.enable = true;
          fixMimeTypes.enable = true;
          defaultApps = {
            enable = true;
            forceMimeAssociations = true;
            editor = {
              inherit (config.programs.helix) package;
              terminal = true;
              icon = "helix";
            };
            terminalEditor.package = config.programs.helix.package;
            webBrowser = {
              inherit (config.programs.helium) package;
              icon = "helium";
            };
          };
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

        sessionVariables = {
          GOPATH = "/home/ayla/.go";
        };

        packages = with pkgs; [
          # libraries
          libsecret
          wl-clipboard
          libnotify
          wl-clipboard
          libnotify

          zip
          xz
          unzip
          p7zip
        ];
      };

      myHome = {
        desktop.gnome.enable = true;

        programs = {
          lutris.enable = true;
        };
      };

      services.flatpak = {
        packages = [
          # creative
          "com.obsproject.Studio"

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
          "org.audacityteam.Audacity"

          # productivity
          "com.calibre_ebook.calibre"

          # utilities
          "com.github.tchx84.Flatseal"
          "org.keepassxc.KeePassXC"
        ];
        update.auto = {
          enable = true;
          onCalendar = "daily";
        };
      };
    })
  ];
}
