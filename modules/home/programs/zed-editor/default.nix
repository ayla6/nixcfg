{
  lib,
  config,
  ...
}: let
  editorCfg = config.mySnippets.editor;

  mkZedFormatter = fmtName:
    if fmtName == null
    then "language_server"
    else let
      f = editorCfg.formatters.${fmtName};
    in
      if f.type == "external"
      then {
        external = {
          command = f.command;
          arguments = f.args or [];
        };
      }
      else if f.type == "lsp"
      then {language_server = {name = fmtName;};}
      else null;

  mkZedLanguage = name: lang:
    lib.filterAttrs (_: v: v != null) {
      formatter = mkZedFormatter lang.formatter;
      language_servers = lang.language-servers ++ lang.zed-only-language-servers;
      code_actions_on_format = lang.code-actions-on-format;
    };

  mkZedLsp = name: srv:
    lib.filterAttrs (_: v: v != null) {
      binary = lib.filterAttrs (_: v: v != null) {
        path = srv.command;
        arguments = srv.args or null;
      };
      settings = srv.config or null;
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
        #"superhtml"
        "marksman"
        "makefile"
        "zig"
        "gleam"
        "glsl"
        "gdscript"
        "svelte"
        "vue"
        "basher"
        "sql"
        #"ruby"
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

        telemetry = {
          diagnostics = false;
          metrics = false;
        };

        languages = lib.listToAttrs (
          lib.attrValues (
            lib.mapAttrs (name: lang: {
              name = lang.full-name;
              value = mkZedLanguage name lang;
            })
            editorCfg.languages
          )
        );
        lsp = lib.mapAttrs mkZedLsp editorCfg.languageServers;
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
      userKeymaps = [
        {
          context = "(vim_mode == helix_normal || vim_mode == helix_select) && !menu";
          bindings = {
            n = "vim::WrappingLeft";
            e = "vim::Down";
            i = "vim::Up";
            o = "vim::WrappingRight";
          };
        }
        {
          context = "vim_mode == helix_normal && !menu";
          bindings = {
            j = "vim::NextWordEnd";
            J = ["vim::NextWordEnd" {ignore_punctuation = true;}];
            k = "vim::MoveToNextMatch";
            K = "vim::MoveToPreviousMatch";
            l = "vim::HelixInsert";
            L = "vim::InsertFirstNonWhitespace";
            h = "vim::InsertLineBelow";
            H = "vim::InsertLineAbove";
          };
        }
        {
          context = "Workspace";
          bindings = {
            ctrl-g = [
              "task::Spawn"
              {
                task_name = "jjui";
                reveal_target = "center";
              }
            ];
          };
        }
      ];
    };
  };
}
