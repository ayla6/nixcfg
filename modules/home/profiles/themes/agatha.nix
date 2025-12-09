{
  lib,
  config,
  ...
}: let
  background = bg;
  foreground = fg;

  bg = "#201d1d";
  bg1 = "#302427";
  bg2 = "#3d3033";
  bg3 = "#4b3d41";
  bg6 = "#8c7b80";
  fg = "#e9d9e0";

  light-pink = "#ffc4ff";
  pink = "#ffa9df";
  comment = "#d88669";

  black = "#010000";
  red = "#ff725c";
  green = "#b7df6b";
  yellow = "#f6c668";
  blue = "#9eddff";
  magenta = "#af54d3";
  cyan = "#6de8c1";
  white = "#e7dade";
  grey = "#cbb7c0";

  dark-red = "#ca5747";

  br_red = red;
  br_green = green;
  br_yellow = yellow;
  br_blue = blue;
  br_magenta = magenta;
  br_cyan = cyan;
  br_white = white;
in {
  # agatha stands for ayla's got a theme(a) or something. very creative i know
  # not yet where i want it to be

  config = lib.mkIf (config.myHome.profiles.theme == "agatha") {
    myHome.profiles.colours = {
      inherit foreground background black red green yellow blue magenta cyan white grey br_red br_green br_yellow br_blue br_magenta br_cyan br_white;
    };

    # used https://github.com/helix-editor/helix/blob/master/runtime/themes/gruber-darker.toml
    # as a template
    programs.helix = {
      settings.theme = "agatha";
      themes.agatha = {
        "keyword" = pink;
        "special" = pink;

        "comment" = comment;
        "comment.unused" = {inherit bg fg;};

        "string" = green;

        "constant" = yellow;
        "constant.builtin" = yellow;
        "constant.character" = yellow;
        "constant.character.escape" = yellow;
        "constant.numeric" = yellow;

        "namespace" = fg;
        "variable" = fg;
        "variable.parameter" = fg;
        "attribute" = fg;
        "punctuation" = fg;
        "function" = fg;
        "constructor" = fg;

        "tag" = fg;
        "label" = fg;

        "type" = fg;
        "type.enum" = fg;
        "type.enum.variant" = fg;

        "module" = light-pink;
        "operator" = light-pink;

        "diff.plus" = green;
        "diff.delta" = yellow;
        "diff.minus" = red;

        "warning" = yellow;
        "error" = red;
        "info" = light-pink;
        "hint" = blue;

        "ui.background" = {inherit bg;};
        "ui.linenr" = bg3;
        "ui.linenr.selected" = light-pink;
        "ui.cursorline" = {bg = bg1;};
        "ui.statusline" = {bg = bg1;};
        "ui.statusline.normal" = {
          fg = bg1;
          bg = pink;
        };
        "ui.statusline.insert" = {
          fg = bg1;
          bg = blue;
        };
        "ui.statusline.select" = {
          fg = bg1;
          bg = light-pink;
        };
        "ui.statusline.inactive" = {bg = bg1;};
        "ui.bufferline" = {
          bg = bg1;
        };
        "ui.bufferline.active" = {bg = bg3;};
        "ui.popup" = {bg = bg1;};
        "ui.window" = bg1;
        "ui.help" = {bg = bg1;};
        "ui.text.directory" = {
          fg = light-pink;
          modifiers = ["bold"];
        };
        "ui.text.focus" = {
          bg = bg1;
          modifiers = ["bold"];
        };
        "ui.selection" = {bg = bg2;};
        "ui.selection.primary" = {bg = bg3;};
        "ui.cursor.primary" = {
          bg = fg;
          fg = bg2;
        };
        "ui.cursor.match" = {
          bg = pink;
          fg = bg2;
        };
        "ui.menu" = {bg = bg1;};
        "ui.menu.selected" = {
          bg = bg3;
          modifiers = ["bold"];
        };
        "ui.virtual.whitespace" = bg1;
        "ui.virtual.indent-guide" = bg1;
        "ui.virtual.ruler" = {bg = bg2;};
        "ui.virtual.inlay-hint" = {fg = bg6;};
        "ui.virtual.wrap" = {fg = bg3;};
        "ui.virtual.jump-label" = {
          fg = dark-red;
          modifiers = ["bold"];
        };

        "diagnostic.warning" = {
          underline = {
            color = yellow;
            style = "dashed";
          };
        };
        "diagnostic.error" = {
          underline = {
            color = dark-red;
            style = "dashed";
          };
        };
        "diagnostic.info" = {
          underline = {
            color = light-pink;
            style = "dashed";
          };
        };
        "diagnostic.hint" = {
          underline = {
            color = blue;
            style = "dashed";
          };
        };
        "diagnostic.unnecessary" = {modifiers = ["dim"];};
        "diagnostic.deprecated" = {modifiers = ["crossed_out"];};

        "markup.heading" = {
          fg = cyan;
          modifiers = ["bold"];
        };
        "markup.bold" = {modifiers = ["bold"];};
        "markup.italic" = {modifiers = ["italic"];};
        "markup.strikethrough" = {modifiers = ["crossed_out"];};
        "markup.link.url" = {
          fg = cyan;
          modifiers = ["underlined"];
        };
        "markup.link.text" = dark-red;
        "markup.raw" = {
          bg = bg1;
          modifiers = ["bold"];
        };
      };
    };
  };
}
