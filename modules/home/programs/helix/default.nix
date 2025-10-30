{
  config,
  lib,
  ...
}: let
  editorCfg = config.mySnippets.editor;

  mkHelixServer = name: srv:
    lib.filterAttrs (_: v: v != null) {
      inherit name;
      command =
        if srv.helix-command != null
        then srv.helix-command
        else srv.command;
      args = srv.args or null;
      config = srv.config or null;
    };

  mkHelixLanguage = name: lang: let
    # this shit is so ugly
    fmtName = lib.findFirst (x: x != null) null [
      (lang.helix-formatter or null)
      (lang.formatter or null)
    ];

    fmt =
      if fmtName != null
      then editorCfg.formatters.${fmtName}
      else null;

    usesLspFormatter = fmt == null || fmt.type == "lsp";

    formatter =
      if fmt != null && fmt.type == "external"
      then
        lib.filterAttrs (_: v: v != null) {
          command = fmt.command;
          args = fmt.args;
        }
      else null;

    fullLspList = lang.language-servers ++ lang.helix-only-language-servers;

    languageServers = map (srvName:
      lib.filterAttrs (_: v: v != null) {
        name = srvName;
        except-features =
          if (usesLspFormatter && fmtName != null && srvName != fmtName)
          then ["format"]
          else null;
      })
    fullLspList;
  in
    lib.filterAttrs (_: v: v != null) {
      name = lang.name;
      auto-format = lang.auto-format;
      language-servers = languageServers;
      file-types = lang.file-types;
      inherit formatter;
    };
in {
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
            "A-t" = "normal_mode";
          };
          insert = {
            "A-t" = "normal_mode";
          };
        };
      };

      languages = {
        language-server = lib.mapAttrs mkHelixServer editorCfg.languageServers;
        language = lib.attrValues (lib.mapAttrs mkHelixLanguage editorCfg.languages);
      };
    };
  };
}
