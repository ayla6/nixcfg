{
  config,
  lib,
  ...
}: let
  editorCfg = config.mySnippets.editor;

  mkHelixServer = name: srv:
    lib.filterAttrs (_: v: v != null) (
      {
        name = name;
        command = srv.command;
      }
      // (
        if (srv.args or []) != []
        then {args = srv.args;}
        else {}
      )
      // (
        if (lib.isAttrs (srv.config or {}) && (builtins.length (builtins.attrNames srv.config)) > 0)
        then {config = srv.config;}
        else {}
      )
    );

  mkHelixLanguage = name: lang: let
    fmtName = lang.helix-formatter or lang.formatter or null;
    fmt =
      if fmtName == null
      then null
      else editorCfg.formatters.${fmtName};

    usesLspFormatter = fmt != null && fmt.type == "lsp";

    formatter =
      if fmt != null && fmt.type == "external"
      then {
        command = fmt.command;
        args = fmt.args or [];
      }
      else null;

    languageServers =
      if usesLspFormatter
      then
        map (
          srvName:
            if srvName == fmt.lspName
            then {
              name = srvName;
              except-features = ["format"];
            }
            else {name = srvName;}
        )
        lang.language-servers
      else map (srvName: {name = srvName;}) lang.language-servers;
  in
    lib.filterAttrs (_: v: v != null) (
      {
        name = lang.name;
        auto-format = lang.auto-format;
        language-servers = languageServers;
      }
      // (
        if lang.file-types != []
        then {file-types = lang.file-types;}
        else {}
      )
      // (
        if formatter != null
        then {inherit formatter;}
        else {}
      )
    );
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
