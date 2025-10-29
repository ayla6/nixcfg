{
  lib,
  config,
  pkgs,
  ...
}: let
  biome = {
    formatter = {language_server = {name = "biome";};};
    code_actions_on_format = {
      "source.fixAll.biome" = true;
      "source.organizeImports.biome" = true;
    };
  };
  prettier = {
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
        "biome"
        "superhtml"
        "marksman"
        "makefile"
        "zig"
        "gleam"
        "glsl"
        "gdscript"
        "svelte"
        #"elixir"
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

        tab_size = 2;
        format_on_save = "on";
        prettier = {
          allowed = false;
        };

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
          JavaScript =
            biome
            // {
              language_servers = [
                "typescript-language-server"
                "biome"
                "!vtsls"
                "!eslint"
              ];
            };
          TypeScript =
            biome
            // {
              language_servers = [
                "typescript-language-server"
                "biome"
                "!vtsls"
                "!eslint"
              ];
            };
          TSX =
            biome
            // {
              language_servers = [
                "typescript-language-server"
                "biome"
                "!vtsls"
                "!eslint"
              ];
            };
          JSON =
            biome
            // {
              language_servers = [
                "json-language-server"
                "biome"
              ];
            };
          JSONC =
            biome
            // {
              language_servers = [
                "json-language-server"
                "biome"
              ];
            };
          CSS =
            biome
            // {
              language_servers = [
                "css-language-server"
                "biome"
              ];
            };
          HTML = {
            formatter = {
              language_server = {
                name = "biome";
              };
            };
            code_actions_on_format = {
              "html.formatter.enabled.biome" = true;
            };
            language_servers = ["vscode-html-language-server" "superhtml" "biome"];
          };
          Nix = {
            formatter = "language_server";
            language_servers = [
              "nixd"
              "nil"
            ];
          };
          Markdown = {
            formatter = prettier;
            language_servers = ["marksman"];
          };
          Fish = {
            formatter = "language_server";
            language_servers = ["fish-lsp"];
          };
          Lua = {
            formatter = {
              external = {
                command = lib.getExe pkgs.stylua;
              };
            };
            language_servers = ["lua-language-server"];
          };
          Go = {
            formatter = "language_server";
            language_servers = ["gopls"];
          };
          Rust = {
            formatter = "language_server";
            language_servers = ["rust-analyzer"];
          };
          Gleam = {
            formatter = "language_server";
            language_servers = ["gleam"];
          };
          # Elixir = {
          #   format_on_save = "on";
          #   formatter = "language_server";
          #   language_servers = ["elixir-ls"];
          # };
          # HEEX = {
          #   format_on_save = "on";
          #   formatter = "language_server";
          #   language_servers = ["elixir-ls"];
          # };
          GLSL = {
            formatter = "language_server";
            language_servers = ["glsl_analyzer"];
          };
          GDScript = {
            formatter = {external = {command = lib.getExe pkgs.gdscript-formatter;};};
            language_servers = ["gdscript-language-server"];
          };
          Bash = {
            language_servers = ["bash-language-server"];
          };
          Svelte =
            biome
            // {
              language_servers = [
                "svelte-language-server"
                "biome"
              ];
            };
        };
        lsp = {
          nixd = {
            binary.path = lib.getExe pkgs.nixd;
            settings.formatting.command = [(lib.getExe pkgs.alejandra) "--quiet" "--"];
          };
          nil = {
            binary = {
              path = lib.getExe pkgs.nil;
              arguments = ["--stdio"];
            };
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
          vscode-html-language-server = {
            binary = {
              path = pkgs.writeScript "vscode-html-language-server-bun" ''
                #! ${pkgs.bash}/bin/bash -e
                exec ${lib.getExe pkgs.bun} ${pkgs.vscode-langservers-extracted}/lib/node_modules/vscode-langservers-extracted/bin/vscode-html-language-server "$@"
              '';
              arguments = ["--stdio"];
            };
          };
          biome = {
            binary = {
              path = lib.getExe pkgs.biome;
              arguments = ["lsp-proxy"];
            };
          };
          superhtml = {
            binary = {
              path = lib.getExe pkgs.superhtml;
              arguments = ["lsp"];
            };
          };
          marksman = {
            binary = {
              path = lib.getExe pkgs.marksman;
              arguments = ["server"];
            };
          };
          fish-lsp = {
            binary = {
              path = lib.getExe pkgs.fish-lsp;
              arguments = ["start"];
            };
          };
          lua-language-server = {
            binary = {
              path = lib.getExe pkgs.lua-language-server;
            };
          };
          gopls = {
            binary = {
              path = lib.getExe pkgs.gopls;
              arguments = ["serve"];
            };
          };
          rust-analyzer = {
            binary = {
              path = lib.getExe pkgs.rust-analyzer;
            };
          };
          zls = {
            binary = {
              path = lib.getExe pkgs.zls;
            };
          };
          gleam = {
            binary = {
              path = lib.getExe pkgs.gleam;
              arguments = ["lsp"];
            };
          };
          glsl_analyzer = {
            binary = {
              path = lib.getExe pkgs.glsl_analyzer;
            };
          };
          #elixir-ls = {
          #  binary = {
          #    path = lib.getExe pkgs.elixir-ls;
          #  };
          #};
          gdscript-language-server = {
            binary = {
              path = lib.getExe pkgs.netcat;
              arguments = ["127.0.0.1" "6005"];
            };
          };
          bash-language-server = {
            binary = {
              path = lib.getExe pkgs.bash-language-server;
              arguments = ["start"];
            };
          };
          svelte-language-server = {
            binary = {
              path = pkgs.writeScript "svelte-language-server-bun" ''
                #! ${pkgs.bash}/bin/bash -e
                exec ${lib.getExe pkgs.bun} ${pkgs.svelte-language-server}/lib/node_modules/svelte-language-server/bin/server.js "$@"
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
      userTasks = [
        {
          label = "jjui";
          command = "jjui";
          hide = "on_success";
          use_new_terminal = true;
          allow_concurrent_runs = false;
          shell = {
            program = "fish";
          };
        }
      ];
    };
  };
}
