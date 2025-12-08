{
  lib,
  config,
  ...
}: let
  background = bg;
  foreground = fg;

  bg = "#181515";
  bg1 = "#2a1e21";
  bg2 = "#372a2d";
  bg3 = "#44363a";
  bg5 = "#6e5e63";
  fg = "#e9d9e0";

  light-pink = "#f19ddf";
  pink = "#ff78bb";
  comment = "#e5939f";

  black = "#010000";
  red = "#ff725c";
  green = "#a9e277";
  yellow = "#ffda5a";
  blue = "#74c6ff";
  magenta = "#af54d3";
  cyan = "#71d4b3";
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

    programs.helix = {
      settings.theme = "agatha";
      themes.agatha = {
        "attribute" = fg;
        "keyword" = {fg = pink;};
        "keyword.directive" = light-pink;
        "namespace" = light-pink;
        "punctuation" = fg;
        "punctuation.delimiter" = fg;
        "operator" = fg;
        "special" = {fg = pink;};
        "variable" = fg;
        "variable.builtin" = {fg = pink;};
        "variable.parameter" = fg;
        "type" = light-pink;
        "constructor" = {fg = light-pink;};
        "function" = light-pink;
        "function.builtin" = pink;
        "tag" = light-pink;
        "comment" = {fg = comment;};
        "constant.character" = {fg = green;};
        "constant.character.escape" = {fg = pink;};
        "constant.builtin" = {fg = pink;};
        "string" = green;
        "constant.numeric" = yellow;
        "label" = fg;
        "module" = light-pink;

        "diff.plus" = green;
        "diff.delta" = light-pink;
        "diff.minus" = red;

        "warning" = {
          fg = yellow;
          modifiers = ["bold"];
        };
        "error" = {
          fg = red;
          modifiers = ["bold"];
        };
        "info" = {
          fg = light-pink;
          modifiers = ["bold"];
        };
        "hint" = {
          fg = blue;
          modifiers = ["bold"];
        };

        "ui.background" = {inherit bg;};
        "ui.linenr" = {fg = bg3;};
        "ui.linenr.selected" = {fg = light-pink;};
        "ui.cursorline" = {bg = bg1;};

        "ui.statusline" = {
          inherit fg;
          bg = bg1;
        };
        "ui.statusline.normal" = {
          fg = bg1;
          bg = pink;
          modifiers = ["bold"];
        };
        "ui.statusline.insert" = {
          fg = bg1;
          bg = blue;
          modifiers = ["bold"];
        };
        "ui.statusline.select" = {
          fg = bg1;
          bg = light-pink;
          modifiers = ["bold"];
        };
        "ui.statusline.inactive" = {
          fg = fg;
          bg = bg1;
        };

        "ui.bufferline" = {
          inherit fg;
          bg = bg1;
        };
        "ui.bufferline.active" = {
          inherit fg;
          bg = bg2;
        };

        "ui.popup" = {bg = bg1;};
        "ui.window" = {fg = bg1;};
        "ui.help" = {
          bg = bg1;
          inherit fg;
        };
        "ui.text" = {inherit fg;};
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
          fg = pink;
        };
        "ui.cursor.match" = {bg = pink;};
        "ui.menu" = {
          inherit fg;
          bg = bg1;
        };
        "ui.menu.selected" = {
          inherit fg;
          bg = bg2;
          modifiers = ["bold"];
        };

        "ui.virtual.whitespace" = bg1;
        "ui.virtual.indent-guide" = bg1;
        "ui.virtual.ruler" = {bg = bg2;};
        "ui.virtual.inlay-hint" = {fg = bg5;};
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
          fg = green;
          modifiers = ["underlined"];
        };
        "markup.link.text" = dark-red;
        "markup.raw" = {
          inherit fg;
          bg = bg1;
          modifiers = ["bold"];
        };
      };
    };
  };
}
