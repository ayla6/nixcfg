{
  pkgs,
  lib,
  config,
  ...
}: {
  options.myHome.programs.yazi.enable = lib.mkEnableOption "yazi fm";

  config = lib.mkIf config.myHome.programs.yazi.enable {
    programs.yazi = {
      enable = true;
      enableFishIntegration = true;
      extraPackages = with pkgs; [
        ripgrep
        ripgrep-all
        fd
        p7zip-rar
        jq
        poppler
        fzf
        zoxide
        resvg
        imagemagick
        wl-clipboard
        ffmpeg
        exiftool
      ];
      settings = {
        mgr = {
          sort = "natural";
          sort_dir_first = true;
          sort_translit = true;
          show_symlink = true;
        };
        preview = {
          wrap = "yes";
          tab_size = 2;
        };
      };
      keymap = {
        mgr.prepend_keymap = [
          {
            on = "i";
            run = "arrow prev";
          }
          {
            on = "e";
            run = "arrow next";
          }

          {
            on = "n";
            run = "leave";
          }
          {
            on = "o";
            run = "enter";
          }

          {
            on = "N";
            run = "back";
          }
          {
            on = "O";
            run = "forward";
          }

          {
            on = "I";
            run = "seek -5";
          }
          {
            on = "E";
            run = "seek 5";
          }

          {
            on = "t";
            run = "open";
          }
          {
            on = "T";
            run = "open --interactive";
          }

          {
            on = "h";
            run = "find_arrow";
          }
          {
            on = "H";
            run = "find_arrow --previous";
          }

          {
            on = "l";
            run = "tab_create --current";
          }
        ];
        tasks.prepend_keymap = [
          {
            on = "i";
            run = "arrow prev";
          }
          {
            on = "e";
            run = "arrow next";
          }
        ];
        spot.prepend_keymap = [
          {
            on = "i";
            run = "arrow prev";
          }
          {
            on = "e";
            run = "arrow next";
          }
          {
            on = "n";
            run = "swipe prev";
          }
          {
            on = "o";
            run = "swipe next";
          }
        ];
        pick.prepend_keymap = [
          {
            on = "i";
            run = "arrow prev";
          }
          {
            on = "e";
            run = "arrow next";
          }
        ];
        input.prepend_keymap = [
          {
            on = "l";
            run = "insert";
          }
          {
            on = "L";
            run = ["move first-char" "insert"];
          }

          {
            on = "n";
            run = "move -1";
          }
          {
            on = "o";
            run = "move 1";
          }
        ];
        confirm.prepend_keymap = [
          {
            on = "n";
            run = "close";
          }
          {
            on = "o";
            run = "close --submit";
          }

          {
            on = "i";
            run = "arrow prev";
          }
          {
            on = "e";
            run = "arrow next";
          }
        ];
        cmp.prepend_keymap = [
          {
            on = "<A-i>";
            run = "arrow prev";
          }
          {
            on = "<A-e>";
            run = "arrow next";
          }
        ];
        help.prepend_keymap = [
          {
            on = "i";
            run = "arrow prev";
          }
          {
            on = "e";
            run = "arrow next";
          }
        ];
      };
    };
  };
}
