_: {
  perSystem = {
    lib,
    pkgs,
    ...
  }: let
    prettier = {
      external = {
        command = pkgs.writeScript "prettier-bun" ''
          #! ${pkgs.bash}/bin/bash -e
          exec ${lib.getExe pkgs.bun} ${pkgs.prettier}/bin/prettier.cjs "$@"
        '';
        arguments = ["--stdin-filepath" "{buffer_path}"];
      };
    };
    biome = {
      format_on_save = "on";

      formatter = {language_server = {name = "biome";};};
      code_actions_on_format = {
        "source.fixAll.biome" = true;
        "source.organizeImports.biome" = true;
      };
    };
  in {
    files.files = [
      {
        checkFile = false;
        path_ = ".zed/settings.json";

        drv = (pkgs.formats.json {}).generate "zed-setting.json" {
          auto_install_extensions = {
            basher = true;
            nix = true;
            marksman = true;
          };

          languages = {
            JSON = biome // {language_servers = ["json-language-server" "biome"];};

            JSONC = biome // {language_servers = ["json-language-server" "biome"];};

            Markdown = {
              format_on_save = "on";
              formatter = prettier;
              language_servers = ["marksman"];
            };

            Nix = {
              format_on_save = "on";
              formatter = "language_server";
              language_servers = [
                "nixd"
                "nil"
              ];
            };

            "Shell Script" = {
              format_on_save = "on";

              formatter = {
                external = {
                  command = lib.getExe pkgs.shfmt;
                  arguments = ["--filename" "{buffer_path}" "-i" "2"];
                };
              };

              tab_size = 2;
              hard_tabs = false;
            };

            YAML = {
              format_on_save = "on";
              formatter = prettier;
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
            json-language-server = {
              binary = {
                path = pkgs.writeScript "vscode-json-languageserver-bun" ''
                  #! ${pkgs.bash}/bin/bash -e
                  exec ${lib.getExe pkgs.bun} ${pkgs.vscode-json-languageserver}/lib/node_modules/vscode-json-languageserver/./bin/vscode-json-languageserver "$@"
                '';
                arguments = ["--stdio"];
              };
            };
            marksman = {
              binary = {
                path = lib.getExe pkgs.marksman;
                arguments = ["server"];
              };
            };
          };
        };
      }
    ];
  };
}
