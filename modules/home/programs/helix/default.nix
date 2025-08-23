{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.helix.enable = lib.mkEnableOption "helix";

  config = lib.mkIf config.myHome.programs.helix.enable {
    programs.helix = {
      enable = true;

      settings = {
        theme = "zed_onedark";

        editor = {
          auto-completion = true;
          auto-format = true;
          auto-pairs = false;
          auto-save = true;
          color-modes = true;
          cursorline = true;

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          indent-guides.render = true;

          lsp = {
            display-inlay-hints = true;
            display-messages = true;
          };

          soft-wrap = {
            enable = true;
            wrap-at-text-width = true;
          };

          statusline.center = ["position-percentage"];
          text-width = 100;
          true-color = true;

          whitespace.characters = {
            newline = "↴";
            tab = "⇥";
          };
        };

        keys = {
          normal = {
            n = "move_char_left";
            e = "move_line_down";
            i = "move_line_up";
            o = "move_char_right";

            j = "move_next_word_end";
            J = "move_next_long_word_end";
            k = "search_next";
            K = "search_prev";
            l = "insert_mode";
            L = "insert_at_line_start";

            h = "open_below";
            H = "open_above";
          };
          select = {
            n = "extend_char_left";
            e = "extend_visual_line_down";
            i = "extend_visual_line_up";
            o = "extend_char_right";
          };
        };
      };
      languages = {
        language-server = {
          bash-language-server = {
            command = "bash-language-server";
            args = ["start"];
          };

          vscode-css-languageserver = {
            command = lib.getExe pkgs.vscode-css-languageserver;
            args = ["--stdio"];
          };

          fish-lsp = {
            command = lib.getExe pkgs.fish-lsp;
            args = ["--stdio"];
          };

          lua-language-server = {
            command = lib.getExe pkgs.lua-language-server;
            args = ["--stdio"];
          };

          marksman = {
            command = lib.getExe pkgs.marksman;
            args = ["--stdio"];
          };

          nixd = {
            command = lib.getExe pkgs.nixd;
          };

          vscode-json-languageserver = {
            command = lib.getExe pkgs.vscode-json-languageserver;
            args = ["--stdio"];
          };

          typescript-language-server = with pkgs.nodePackages; {
            command = "${typescript-language-server}/bin/typescript-language-server";
            args = ["--stdio" "--tsserver-path=${typescript}/lib/node_modules/typescript/lib"];
          };

          superhtml = {
            command = lib.getExe pkgs.superhtml;
            args = ["--stdio"];
          };
        };

        language = [
          {
            name = "bash";
            auto-format = true;
            file-types = ["sh" "bash" "dash" "ksh" "mksh"];

            formatter = {
              command = lib.getExe pkgs.shfmt;
              args = ["-i" "2"];
            };

            language-servers = ["bash-language-server"];
          }
          {
            name = "css";
            auto-format = true;
            formatter = {command = lib.getExe pkgs.prettier;};
            language-servers = ["vscode-css-languageserver"];
          }
          {
            name = "fish";
            auto-format = true;
            language-servers = ["fish-lsp"];
          }
          {
            name = "html";
            auto-format = true;
            formatter = {command = lib.getExe pkgs.prettier;};
            language-servers = ["superhtml"];
          }
          {
            name = "javascript";
            auto-format = true;
            formatter = {command = lib.getExe pkgs.prettier;};
            language-servers = ["typescript-language-server"];
          }
          {
            name = "json";
            auto-format = true;
            formatter = {command = lib.getExe pkgs.prettier;};
            language-servers = ["vscode-json-languageserver"];
          }
          {
            name = "lua";
            auto-format = true;
            formatter = {command = lib.getExe pkgs.stylua;};
            language-servers = ["lua-language-server"];
          }
          {
            name = "markdown";
            auto-format = true;
            formatter = {command = lib.getExe pkgs.mdformat;};
            language-servers = ["marksman"];
          }
          {
            name = "nix";
            auto-format = true;
            formatter = {command = lib.getExe pkgs.alejandra;};
            language-servers = ["nixd"];
          }
          {
            name = "typescript";
            auto-format = true;
            formatter = {command = lib.getExe pkgs.prettier;};
            language-servers = ["typescript-language-server"];
          }
        ];
      };
    };
  };
}
