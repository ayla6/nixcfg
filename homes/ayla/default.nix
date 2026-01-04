{
  pkgs,
  lib,
  ...
}: {
  config = lib.mkMerge [
    {
      home = {
        packages = with pkgs; [
          # development
          luajit
          bun
          typescript
          # clang
          # rustc
          # cargo
          clippy
          cloc

          # applications
          aseprite
          rclone
          #rclone-browser
          yt-dlp

          fend
          libqalculate

          bchunk
          mame-tools
          compsize
        ];

        username = "ayla";
        stateVersion = "25.05";
      };

      programs.home-manager.enable = true;
      programs.helium.package = lib.mkForce null;

      xdg.enable = true;

      myHome = {
        desktop.enable = true;
        programs = {
          helium.enable = true;
          fastfetch.enable = true;
          # firefox = {
          #   enable = true;
          #   mode = "sidebar";
          # };
          git.enable = true;
          helix.enable = true;
          jujutsu.enable = true;
          # mpv.enable = true;
          ssh.enable = true;
          # zed-editor.enable = true;
          yazi.enable = true;
          foot.enable = true;
        };

        profiles = {
          betterLocations.enable = true;
          shell.enable = true;
        };
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
          SUDO_EDITOR = "hx";
          EDITOR = "hx";
          QT_IM_MODULE = "fcitx";
          XMODIFIERS = "@im=fcitx";
        };
      };
    })
  ];
}
