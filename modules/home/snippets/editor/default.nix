{
  lib,
  pkgs,
  ...
}: let
  # Helper function to create language server definitions
  mkLspServer = name: {
    command,
    helix-command ? null,
    args ? null,
    config ? null,
  }: {
    inherit name command helix-command args config;
  };

  # Helper function to create formatter definitions
  mkFormatter = name: {
    type,
    command ? null,
    args ? null,
    lspName ? null,
    config ? null,
  }: {
    inherit name type command args lspName config;
  };

  # Helper function to create language definitions
  mkLanguage = name: {
    full-name ? name,
    auto-format ? true,
    file-types ? null,
    language-servers ? [],
    zed-only-language-servers ? [],
    helix-only-language-servers ? [],
    formatter ? null,
    helix-formatter ? null,
    code-actions-on-format ? null,
  }: {
    inherit name full-name auto-format file-types language-servers zed-only-language-servers helix-only-language-servers formatter helix-formatter code-actions-on-format;
  };
in {
  options.mySnippets.editor = lib.mkOption {
    type = lib.types.attrs;
    default = {};
    description = "Editor configuration data";
  };

  config.mySnippets.editor = {
    # Language Servers
    languageServers = {
      biome = mkLspServer "biome" {
        command = lib.getExe pkgs.biome;
        args = ["lsp-proxy"];
      };

      tailwindcss-language-server = mkLspServer "tailwindcss-language-server" {
        command = pkgs.writeScript "tailwindcss-language-server-bun" ''
          #!${lib.getExe pkgs.bash} -e
          exec ${lib.getExe pkgs.bun} ${lib.getExe pkgs.tailwindcss-language-server}
        '';
        helix-command = let
          fd = lib.getExe pkgs.fd;
          xargs = "${pkgs.uutils-findutils}/bin/xargs";
          grep = lib.getExe pkgs.gnugrep;
          bun = lib.getExe pkgs.bun;
          twls = lib.getExe pkgs.tailwindcss-language-server;
        in
          pkgs.writeScript "tailwindcss-language-server-bun-helix" ''
            #!${lib.getExe pkgs.bash} -euo

            if ! ${fd} -H -I -E "node_modules" "package\\.json$" . | \
              ${xargs} ${grep} -q '"tailwindcss"'; then

              exit 0
            fi

            exec ${bun} ${twls}
          '';
        args = [];
        config = {provideFormatter = false;};
      };

      vscode-html-language-server = mkLspServer "vscode-html-language-server" {
        command = lib.getExe pkgs.bun;
        args = ["${pkgs.vscode-langservers-extracted}/lib/node_modules/vscode-langservers-extracted/bin/vscode-html-language-server" "--stdio"];
      };

      superhtml = mkLspServer "superhtml" {
        command = lib.getExe pkgs.superhtml;
        args = ["lsp"];
      };

      css-language-server = mkLspServer "css-language-server" {
        command = lib.getExe pkgs.bun;
        args = ["${pkgs.vscode-css-languageserver}/lib/node_modules/vscode-css-languageserver/out/node/cssServerMain.js" "--stdio"];
      };

      json-language-server = mkLspServer "json-language-server" {
        command = lib.getExe pkgs.bun;
        args = ["${pkgs.vscode-json-languageserver}/lib/node_modules/vscode-json-languageserver/bin/vscode-json-languageserver" "--stdio"];
      };

      vtsls = mkLspServer "vtsls" {
        command = lib.getExe pkgs.bun;
        args = ["${pkgs.vtsls}/bin/vtsls" "--stdio"];
      };

      svelte-language-server = mkLspServer "svelte-language-server" {
        command = lib.getExe pkgs.bun;
        args = ["${pkgs.svelte-language-server}/lib/node_modules/svelte-language-server/bin/server.js" "--stdio"];
      };

      vue-language-server = mkLspServer "vue-language-server" {
        command = lib.getExe pkgs.bun;
        args = ["${pkgs.vue-language-server}/lib/language-tools/packages/language-server/bin/vue-language-server.js" "--stdio"];
      };

      bash-language-server = mkLspServer "bash-language-server" {
        command = lib.getExe pkgs.bash-language-server;
        args = ["start"];
      };

      fish-lsp = mkLspServer "fish-lsp" {
        command = lib.getExe pkgs.fish-lsp;
        args = ["start"];
      };

      nixd = mkLspServer "nixd" {
        command = lib.getExe pkgs.nixd;
        config.formatting.command = [(lib.getExe pkgs.alejandra) "--quiet" "--"];
      };

      nil = mkLspServer "nil" {
        command = lib.getExe pkgs.nil;
        args = ["--stdio"];
      };

      marksman = mkLspServer "marksman" {
        command = lib.getExe pkgs.marksman;
        args = ["server"];
      };

      gopls = mkLspServer "gopls" {
        command = lib.getExe pkgs.gopls;
        args = ["serve"];
      };

      rust-analyzer = mkLspServer "rust-analyzer" {
        command = lib.getExe pkgs.rust-analyzer;
      };

      zls = mkLspServer "zls" {
        command = lib.getExe pkgs.zls;
      };

      glsl_analyzer = mkLspServer "glsl_analyzer" {
        command = lib.getExe pkgs.glsl_analyzer;
      };

      lua-language-server = mkLspServer "lua-language-server" {
        command = lib.getExe pkgs.lua-language-server;
      };

      gleam = mkLspServer "gleam" {
        command = lib.getExe pkgs.gleam;
        args = ["lsp"];
      };

      gdscript-language-server = mkLspServer "gdscript-language-server" {
        command = lib.getExe pkgs.netcat;
        args = ["127.0.0.1" "6005"];
        config = {language-id = "gdscript";};
      };

      solargraph = mkLspServer "solargraph" {
        command = lib.getExe pkgs.rubyPackages.solargraph;
        args = ["stdio"];
      };

      #rubocop = mkLspServer "rubocop" {
      #  command = lib.getExe pkgs.rubocop;
      #};
    };

    # Formatters
    formatters = {
      biome = mkFormatter "biome" {
        type = "lsp";
      };

      biomeHtml = mkFormatter "biomeHtml" {
        type = "external";
        command = lib.getExe pkgs.biome;
        args = ["format" "--use-server" "--html-formatter-enabled=true" "--stdin-file-path" "{buffer_path}"];
      };

      shfmt = mkFormatter "shfmt" {
        type = "external";
        command = lib.getExe pkgs.shfmt;
        args = ["-i" "2"];
      };

      alejandra = mkFormatter "alejandra" {
        type = "external";
        command = lib.getExe pkgs.alejandra;
      };

      mdformat = mkFormatter "mdformat" {
        type = "external";
        command = lib.getExe pkgs.mdformat;
      };

      stylua = mkFormatter "stylua" {
        type = "external";
        command = lib.getExe pkgs.stylua;
      };

      gdscript-formatter = mkFormatter "gdscript-formatter" {
        type = "external";
        command = lib.getExe pkgs.gdscript-formatter;
      };

      prettier = mkFormatter "prettier" {
        type = "external";
        command = lib.getExe pkgs.bun;
        args = ["${pkgs.prettier}/bin/prettier.cjs" "--stdin-filepath" "{buffer_path}"];
      };
    };

    # Languages
    languages = {
      html = mkLanguage "html" {
        full-name = "HTML";
        language-servers = ["vscode-html-language-server" "biome"];
        zed-only-language-servers = ["!eslint" "..."];
        helix-only-language-servers = ["tailwindcss-language-server"];
        formatter = "biome";
        helix-formatter = "biomeHtml";
        code-actions-on-format = {
          "source.fixAll.biome" = true;
          "html.formatter.enabled.biome" = true;
        };
      };

      css = mkLanguage "css" {
        full-name = "CSS";
        language-servers = ["css-language-server" "biome"];
        zed-only-language-servers = ["..."];
        helix-only-language-servers = ["tailwindcss-language-server"];
        formatter = "biome";
        code-actions-on-format = {
          "source.fixAll.biome" = true;
          "source.organizeImports.biome" = true;
        };
      };

      javascript = mkLanguage "javascript" {
        full-name = "JavaScript";
        language-servers = ["vtsls" "biome"];
        zed-only-language-servers = ["!eslint" "!typescript-language-server" "..."];
        helix-only-language-servers = ["tailwindcss-language-server"];
        formatter = "biome";
        code-actions-on-format = {
          "source.fixAll.biome" = true;
          "source.organizeImports.biome" = true;
        };
      };

      typescript = mkLanguage "typescript" {
        full-name = "TypeScript";
        language-servers = ["vtsls" "biome"];
        zed-only-language-servers = ["!eslint" "!typescript-language-server" "..."];
        helix-only-language-servers = ["tailwindcss-language-server"];
        formatter = "biome";
        code-actions-on-format = {
          "source.fixAll.biome" = true;
          "source.organizeImports.biome" = true;
        };
      };

      jsx = mkLanguage "jsx" {
        full-name = "JSX";
        language-servers = ["vtsls" "biome"];
        zed-only-language-servers = ["!eslint" "!typescript-language-server" "..."];
        helix-only-language-servers = ["tailwindcss-language-server"];
        formatter = "biome";
        code-actions-on-format = {
          "source.fixAll.biome" = true;
          "source.organizeImports.biome" = true;
        };
      };

      tsx = mkLanguage "tsx" {
        full-name = "TSX";
        language-servers = ["vtsls" "biome"];
        zed-only-language-servers = ["!eslint" "!typescript-language-server" "..."];
        helix-only-language-servers = ["tailwindcss-language-server"];
        formatter = "biome";
        code-actions-on-format = {
          "source.fixAll.biome" = true;
          "source.organizeImports.biome" = true;
        };
      };

      svelte = mkLanguage "svelte" {
        full-name = "Svelte";
        language-servers = ["svelte-language-server" "vtsls" "biome"];
        zed-only-language-servers = ["!eslint" "!typescript-language-server" "..."];
        helix-only-language-servers = ["tailwindcss-language-server"];
        formatter = "biome";
        code-actions-on-format = {
          "source.fixAll.biome" = true;
          "source.organizeImports.biome" = true;
        };
      };

      vue = mkLanguage "vue" {
        full-name = "Vue.js";
        language-servers = ["vue-language-server" "biome"];
        zed-only-language-servers = ["!eslint" "!typescript-language-server" "..."];
        helix-only-language-servers = ["tailwindcss-language-server"];
        formatter = "biome";
        code-actions-on-format = {
          "source.fixAll.biome" = true;
          "source.organizeImports.biome" = true;
        };
      };

      json = mkLanguage "json" {
        full-name = "JSON";
        language-servers = ["json-language-server" "biome"];
        formatter = "biome";
        code-actions-on-format = {
          "source.fixAll.biome" = true;
        };
      };

      jsonc = mkLanguage "jsonc" {
        full-name = "JSONC";
        language-servers = ["json-language-server" "biome"];
        formatter = "biome";
        code-actions-on-format = {
          "source.fixAll.biome" = true;
          "source.organizeImports.biome" = true;
        };
      };

      bash = mkLanguage "bash" {
        full-name = "Shell Script";
        file-types = ["sh" "bash" "dash" "ksh" "mksh"];
        language-servers = ["bash-language-server"];
        formatter = "shfmt";
      };

      fish = mkLanguage "fish" {
        full-name = "Fish";
        language-servers = ["fish-lsp"];
      };

      nix = mkLanguage "nix" {
        full-name = "Nix";
        language-servers = ["nixd" "nil"];
        formatter = "alejandra";
      };

      markdown = mkLanguage "markdown" {
        full-name = "Markdown";
        language-servers = ["marksman"];
        formatter = "prettier";
      };

      go = mkLanguage "go" {
        full-name = "Go";
        language-servers = ["gopls"];
      };

      rust = mkLanguage "rust" {
        full-name = "Rust";
        language-servers = ["rust-analyzer"];
      };

      zig = mkLanguage "zig" {
        full-name = "Zig";
        language-servers = ["zls"];
      };

      glsl = mkLanguage "glsl" {
        full-name = "GLSL";
        language-servers = ["glsl_analyzer"];
      };

      lua = mkLanguage "lua" {
        full-name = "Lua";
        language-servers = ["lua-language-server"];
        formatter = "stylua";
      };

      gleam = mkLanguage "gleam" {
        full-name = "Gleam";
        language-servers = ["gleam"];
      };

      gdscript = mkLanguage "gdscript" {
        full-name = "GDScript";
        language-servers = ["gdscript-language-server"];
        formatter = "gdscript-formatter";
      };

      #ruby = mkLanguage "ruby" {
      #  full-name = "Ruby";
      #  language-servers = ["solargraph" "rubocop"];
      #};
    };
  };
}
