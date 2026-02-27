{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.profiles.shell.enable = lib.mkEnableOption "basic shell environment";

  config = lib.mkIf config.myHome.profiles.shell.enable {
    myHome.programs = {
      zellij.enable = true;
      fish.enable = true;
    };

    home = {
      packages = with pkgs; [
        (lib.hiPrio uutils-coreutils-noprefix)
        curl
        nixos-rebuild
        wget
        imagemagick
        # wl-clipboard
        # p7zip-rar
        zip
        xz
        unzip
        libnotify
        sd
        file
      ];

      sessionVariables = {
        RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
      };

      shellAliases = {
        l = "eza -lah";
        tree = "eza --tree";
        top = "btop";
        cat = "bat -pp";
        ytmusic = "yt-dlp --js-runtimes deno:${lib.getExe pkgs.deno} -f 251 --remux-video opus --embed-metadata --cookies-from-browser chromium --parse-metadata \"%(track_number,playlist_index)s:%(meta_track)s\" -o \"%(album)s/%(disc_number,1)02d-%(track_number,playlist_index)02d %(title)s.%(ext)s\"";
        nix-shell = "nix-shell --run fish";
      };
    };

    programs = {
      bat.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;

        stdlib = ''
          : ''${XDG_CACHE_HOME:=$HOME/.cache}
          declare -A direnv_layout_dirs

          direnv_layout_dir() {
            echo "''${direnv_layout_dirs[$PWD]:=$(
              echo -n "$XDG_CACHE_HOME"/direnv/layouts/
              echo -n "$PWD" | sha1sum | cut -d ' ' -f 1
            )}"
          }
        '';
      };

      eza = {
        enable = true;
        enableFishIntegration = true;
        extraOptions = [
          "--group-directories-first"
          "--header"
        ];
        git = true;
        icons = "auto";
      };

      fd = {
        enable = true;
      };

      fzf.enable = true;

      ripgrep = {
        enable = true;
        arguments = ["--pretty"];
      };

      ripgrep-all.enable = true;

      zoxide = {
        enable = true;
        enableFishIntegration = true;
        options = ["--cmd cd"];
      };
    };
  };
}
