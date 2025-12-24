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
        btop
        nixos-rebuild
        wget
        imagemagick
        wl-clipboard
        p7zip-rar
        zip
        xz
        unzip
        wl-clipboard
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
        ytmusic = "yt-dlp -f 251 --remux-video opus --embed-metadata --embed-thumbnail -o \"%(album)s/%(disc_number>0)s%(disc_number)02d-%(track_number)02d %(title)s.%(ext)s\"";
        nix-shell = "nix-shell --run fish";
      };
    };

    programs = {
      bat.enable = true;
      btop.enable = true;

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
