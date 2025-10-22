{
  lib,
  config,
  pkgs,
  ...
}: let
  bunPrettier = {
    external = {
      command = pkgs.writeScript "prettier-bun" ''
        #! ${pkgs.bash}/bin/bash -e
        exec ${lib.getExe pkgs.bun} ${pkgs.prettier}/bin/prettier.cjs "$@"
      '';
      arguments = ["--stdin-filepath" "{buffer_path}"];
    };
  };
in {
  options.myHome.programs.zed-editor.enable = lib.mkEnableOption "zed editor";

  config = lib.mkIf config.myHome.programs.zed-editor.enable {
    programs.zed-editor = {
      enable = true;
      extensions = [
        "env"
        "fish"
        "git-firefly"
        "github-theme"
        "html"
        "lua"
        "nix"
        "scss"
        "toml"
      ];
      userSettings = {
        auto_indent_on_paste = true;
        auto_update = false;
        buffer_font_size = 14;
        ui_font_size = 14;
        buffer_font_family = "JetBrainsMono Nerd Font";
        use_on_type_format = true;
        wrap_guides = [100];
        minimap.show = "auto";
        preferred_line_length = 100;
        soft_wrap = "preferred_line_length";

        agent = {
          default_model = {
            provider = "google";
            model = "gemini-2.5-pro";
          };
          inline_assistant_model = {
            provider = "google";
            model = "gemini-2.5-pro";
          };
          default_profile = "ask";
        };

        languages = {
          JavaScript = {
            format_on_save = "on";

            formatter = bunPrettier;
            language_servers = [
              "typescript-language-server"
              "!vtsls"
              "!eslint"
            ];
          };
          TypeScript = {
            format_on_save = "on";

            formatter = bunPrettier;
            language_servers = [
              "typescript-language-server"
              "!vtsls"
              "!eslint"
            ];
          };
          TSX = {
            format_on_save = "on";

            formatter = bunPrettier;
            language_servers = [
              "typescript-language-server"
              "!vtsls"
              "!eslint"
            ];
          };
          JSON = {
            format_on_save = "on";

            formatter = bunPrettier;
          };
          CSS = {
            format_on_save = "on";

            formatter = bunPrettier;
          };
          Nix = {
            format_on_save = "on";
            formatter = "language_server";
            language_servers = [
              "nixd"
            ];
          };
        };
        lsp = {
          nixd = {
            binary.path = lib.getExe pkgs.nixd;
            settings.formatting.command = [(lib.getExe pkgs.alejandra) "--quiet" "--"];
          };
          typescript-language-server = with pkgs.nodePackages; {
            binary = {
              path = pkgs.writeScript "typescript-language-server-bun" ''
                #! ${pkgs.bash}/bin/bash -e
                exec ${lib.getExe pkgs.bun} ${typescript-language-server}/lib/node_modules/typescript-language-server/lib/cli.mjs "$@"
              '';
              arguments = ["--stdio"];
            };
          };
          json-language-server = {
            binary = {
              path = pkgs.writeScript "vscode-json-languageserver-bun" ''
                #! ${pkgs.bash}/bin/bash -e
                exec ${lib.getExe pkgs.bun} ${pkgs.vscode-json-languageserver}/lib/node_modules/vscode-json-languageserver/./bin/vscode-json-languageserver "$@"
              '';
              arguments = ["--stdio"];
            };
          };
          css-language-server = {
            binary = {
              path = pkgs.writeScript "vscode-css-languageserver-bun" ''
                #! ${pkgs.bash}/bin/bash -e
                exec ${lib.getExe pkgs.bun} ${pkgs.vscode-css-languageserver}/lib/node_modules/vscode-css-languageserver/out/node/cssServerMain.js "$@"
              '';
              arguments = ["--stdio"];
            };
          };
        };
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
      };
    };
  };
}
