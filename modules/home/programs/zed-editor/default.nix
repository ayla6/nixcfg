{
  lib,
  config,
  pkgs,
  ...
}: {
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
        buffer_font_family = "JetBrains Mono NL";
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

            formatter = {
              external = {
                command = lib.getExe pkgs.prettier;
                arguments = ["--stdin-filepath" "{buffer_path}"];
              };
            };
          };
          TypeScript = {
            format_on_save = "on";

            formatter = {
              external = {
                command = lib.getExe pkgs.prettier;
                arguments = ["--stdin-filepath" "{buffer_path}"];
              };
            };
          };
          TSX = {
            format_on_save = "on";

            formatter = {
              external = {
                command = lib.getExe pkgs.prettier;
                arguments = ["--stdin-filepath" "{buffer_path}"];
              };
            };
          };
          Nix = {
            format_on_save = "on";
            formatter = "language_server";
            language_servers = [
              "nixd"
            ];
          };
          JSON = {
            format_on_save = "on";

            formatter = {
              external = {
                command = lib.getExe pkgs.prettier;
                arguments = ["--stdin-filepath" "{buffer_path}"];
              };
            };
          };
          CSS = {
            format_on_save = "on";

            formatter = {
              external = {
                command = lib.getExe pkgs.prettier;
                arguments = ["--stdin-filepath" "{buffer_path}"];
              };
            };
          };
        };
        lsp.nixd = {
          binary.path = lib.getExe pkgs.nixd;
          settings.formatting.command = [(lib.getExe pkgs.alejandra) "--quiet" "--"];
        };
        telemetry = {
          diagnostics = false;
          metrics = false;
        };
      };
    };
  };
}
