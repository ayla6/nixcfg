{
  config,
  lib,
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
            h = "move_line_left";
            n = "move_line_down";
            e = "move_line_up";
            i = "move_char_right";

            j = "move_next_word_end";
            J = "move_next_long_word_end";
            k = "search_next";
            K = "search_prev";
            l = "insert_mode";
            L = "insert_at_line_start";
          };
          select = {
            h = "extend_visual_line_left";
            n = "extend_visual_line_down";
            e = "extend_visual_line_up";
            i = "extend_char_right";
          };
        };
      };
    };
  };
}
