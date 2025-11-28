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

      sessionVariables = {
        RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
      };

      shellAliases = {
        l = "eza -lah";
        tree = "eza --tree";
        top = "btop";
        cat = "bat -p -P";
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

      fish = {
        enable = true;
        interactiveShellInit = ''
          set -gx PATH $PATH /home/$USER/.local/bin
        '';
      };

      fzf.enable = true;

      ripgrep = {
        enable = true;
        arguments = ["--pretty"];
      };

      ripgrep-all.enable = true;

      zellij = {
        enable = true;
        enableFishIntegration = false;
        settings = {
          theme = "onedark";
          default_shell = "fish";
          show_startup_tips = false;
          pane_frames = false;
          default_layout = "compact";
          keybinds = {unbind = "Ctrl q";};
          ui = {pane_frames = {rounded_corners = true;};};
        };
        extraConfig = ''
          plugins {
              compact-bar location="zellij:compact-bar" {
                tooltip "F1"
              }
          }
        '';
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
        options = ["--cmd cd"];
      };

      broot = {
        enable = true;
        enableFishIntegration = true;
        modal = true;
        settings = {
          verbs = [
            {
              key = "o";
              execution = ":open_stay";
            }
            {
              key = "n";
              execution = ":parent";
            }
            {
              key = "e";
              execution = ":line_down";
            }
            {
              key = "i";
              execution = ":line_up";
            }
            {
              key = "j";
              execution = ":create {new_file}";
            }
            {
              key = "k";
              execution = "$EDITOR {file}";
            }
            {
              key = "l";
              execution = ":toggle_git_ignore";
            }
          ];
        };
      };
    };
  };
}
