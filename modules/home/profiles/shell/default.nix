{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.profiles.shell.enable = lib.mkEnableOption "basic shell environment";

  config = lib.mkIf config.myHome.profiles.shell.enable {
    home = {
      packages = with pkgs; [
        (lib.hiPrio uutils-coreutils-noprefix)
        curl
        btop
        nixos-rebuild
        wget
      ];

      shellAliases = {
        l = "eza -lah";
        tree = "eza --tree";
        top = "btop";
        npm = "pnpm";
        ytmusic = "yt-dlp -f 251 --remux-video opus --embed-metadata --embed-thumbnail -o \"%(album)s/%(disc_number>0)s%(disc_number)02d-%(track_number)02d %(title)s.%(ext)s\"";
      };
    };

    programs = {
      bat.enable = true;

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

      fish = {
        enable = true;
        interactiveShellInit = ''
          set -gx PATH $PATH /home/$USER/.local/bin
        '';
      };

      fzf.enable = true;
      btop.enable = true;

      zellij = {
        enable = true;
        enableFishIntegration = false;
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
        options = ["--cmd cd"];
      };
    };
  };
}
