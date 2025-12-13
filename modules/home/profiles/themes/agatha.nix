{
  lib,
  config,
  pkgs,
  ...
}: let
  bg = "#232124";
  fg = "#e9d9e0";
  bg1 = "#2a282b";
  bg2 = "#353137";
  bg3 = "#454048";
  bg4 = "#534e56";

  black = "#010000";
  red = "#fd7b64";
  green = "#9bd26c";
  yellow = "#f6c668";
  blue = "#8cc0f2";
  magenta = "#d89ae1";
  cyan = "#8dd7d1";
  white = "#e7dade";
  grey = "#cbb7c0";

  pink = "#fc90c1";

  light-pink = "#ffc4ff";

  dark-red = "#eb5747";
  dark-green = "#82af3a";
  dark-yellow = "#f0a943";
  dark-blue = "#2d96d8";
  dark-magenta = "#ad6dcd";
  dark-cyan = "#0cb0a0";
  dark-white = "#b0a4a7";

  background = bg;
  foreground = fg;

  br_red = dark-red;
  br_green = dark-green;
  br_yellow = dark-yellow;
  br_blue = dark-blue;
  br_magenta = dark-magenta;
  br_cyan = dark-cyan;
  br_white = dark-white;

  # this thing here was claude. kind of silly but if it works
  hexToRgb = hex: let
    cleanHex =
      if builtins.substring 0 1 hex == "#"
      then builtins.substring 1 (-1) hex
      else hex;
    r = builtins.fromTOML "x=0x${builtins.substring 0 2 cleanHex}";
    g = builtins.fromTOML "x=0x${builtins.substring 2 2 cleanHex}";
    b = builtins.fromTOML "x=0x${builtins.substring 4 2 cleanHex}";
  in "${toString r.x} ${toString g.x} ${toString b.x}";

  coloursNh = config.myHome.profiles.coloursNoHash;
in {
  # agatha stands for ayla's got a theme(a) or something. very creative i know
  # not yet where i want it to be

  config = lib.mkMerge [
    (lib.mkIf (config.myHome.profiles.theme == "agatha") {
      myHome.profiles.colours = {
        inherit fg foreground background black red green yellow blue magenta cyan white grey br_red br_green br_yellow br_blue br_magenta br_cyan br_white bg bg1 bg2 bg3 bg4;
        accent = pink;
        light_accent = light-pink;
      };

      programs = {
        helix.settings.theme = "agatha";
        zellij.settings.theme = "agatha";
        bat.config.theme = "agatha";
        swaylock.settings = {
          color = coloursNh.bg;

          indicator-radius = 100;
          indicator-thickness = 12;

          inside-color = coloursNh.bg1;
          ring-color = coloursNh.accent;
          line-color = coloursNh.accent;
          text-color = coloursNh.fg;

          inside-clear-color = coloursNh.bg2;
          ring-clear-color = coloursNh.blue;
          line-clear-color = coloursNh.blue;
          text-clear-color = coloursNh.fg;

          inside-ver-color = coloursNh.bg3;
          ring-ver-color = coloursNh.cyan;
          line-ver-color = coloursNh.cyan;
          text-ver-color = coloursNh.fg;

          inside-wrong-color = coloursNh.bg4;
          ring-wrong-color = coloursNh.red;
          line-wrong-color = coloursNh.red;
          text-wrong-color = coloursNh.red;

          inside-caps-lock-color = coloursNh.bg1;
          ring-caps-lock-color = coloursNh.yellow;
          line-caps-lock-color = coloursNh.yellow;
          text-caps-lock-color = coloursNh.yellow;

          key-hl-color = coloursNh.light_accent;
          bs-hl-color = coloursNh.accent;
          separator-color = coloursNh.bg;

          layout-text-color = coloursNh.fg;
          layout-bg-color = coloursNh.bg1;
          layout-border-color = coloursNh.accent;
        };
      };
    })

    # used https://github.com/helix-editor/helix/blob/master/runtime/themes/gruber-darker.toml
    # as a template
    {
      programs = {
        helix.themes.agatha = {
          "keyword" = pink;
          "special" = pink;
          "type.builtin" = pink;
          "constant.builtin" = pink;
          "variable.builtin" = pink;
          "tag.builtin" = pink;

          "comment" = dark-yellow;
          "comment.unused" = {inherit bg fg;};

          "string" = green;

          "constant" = fg;

          "constant.character" = cyan;
          "constant.character.escape" = cyan;
          "constant.numeric" = cyan;

          "variable" = fg;
          "variable.parameter" = fg;
          "attribute" = fg;
          "punctuation" = fg;

          "function" = fg;
          "constructor" = fg;

          "tag" = fg;
          "label" = fg;

          "type" = cyan;
          "type.enum" = cyan;
          "type.enum.variant" = cyan;
          "namespace" = cyan;
          "module" = cyan;

          "operator" = fg;

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
            fg = pink;
            # modifiers = ["bold"];
          };
          "ui.text.focus" = {
            bg = bg1;
            # modifiers = ["bold"];
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
            # modifiers = ["bold"];
          };
          "ui.virtual.whitespace" = bg1;
          "ui.virtual.indent-guide" = bg1;
          "ui.virtual.ruler" = {bg = bg2;};
          "ui.virtual.inlay-hint" = {fg = bg4;};
          "ui.virtual.wrap" = {fg = bg3;};
          "ui.virtual.jump-label" = {
            fg = dark-red;
            # modifiers = ["bold"];
          };

          # Cozette doesn't support dashed or strikethrough
          "diagnostic.warning" = {
            underline = {
              color = yellow;
              style = "line";
              # style = "dashed";
            };
          };
          "diagnostic.error" = {
            underline = {
              color = dark-red;
              style = "line";
              # style = "dashed";
            };
          };
          "diagnostic.info" = {
            underline = {
              color = light-pink;
              style = "line";
              # style = "dashed";
            };
          };
          "diagnostic.hint" = {
            underline = {
              color = blue;
              style = "line";
              # style = "dashed";
            };
          };
          "diagnostic.unnecessary" = {modifiers = ["dim"];};
          "diagnostic.deprecated" = {bg = dark-yellow;};
          # "diagnostic.deprecated" = {modifiers = ["crossed_out"];};

          "markup.heading" = {
            fg = cyan;
            modifiers = ["bold"];
          };
          "markup.bold" = {modifiers = ["bold"];};
          "markup.italic" = {modifiers = ["italic"];};
          "markup.strikethrough" = {bg = dark-red;};
          # "markup.strikethrough" = {modifiers = ["crossed_out"];};
          "markup.link.url" = {
            fg = blue;
            underline = {style = "line";};
          };
          "markup.link.text" = dark-red;
          "markup.raw" = {
            bg = bg1;
            modifiers = ["bold"];
          };
        };

        bat.themes.agatha = {
          src = pkgs.writeText "agatha.tmTheme" ''
            <?xml version="1.0" encoding="UTF-8"?>
            <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
            <plist version="1.0">
            <dict>
              <key>name</key>
              <string>Agatha</string>
              <key>settings</key>
              <array>
                <dict>
                  <key>settings</key>
                  <dict>
                    <key>background</key>
                    <string>${bg}</string>
                    <key>caret</key>
                    <string>${fg}</string>
                    <key>foreground</key>
                    <string>${fg}</string>
                    <key>lineHighlight</key>
                    <string>${bg1}</string>
                    <key>selection</key>
                    <string>${bg2}</string>
                  </dict>
                </dict>
                <dict>
                  <key>name</key>
                  <string>Comment</string>
                  <key>scope</key>
                  <string>comment</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>${dark-yellow}</string>
                  </dict>
                </dict>
                <dict>
                  <key>name</key>
                  <string>String</string>
                  <key>scope</key>
                  <string>string</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>${green}</string>
                  </dict>
                </dict>
                <dict>
                  <key>name</key>
                  <string>Constant</string>
                  <key>scope</key>
                  <string>entity.name.type</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>${light-pink}</string>
                  </dict>
                </dict>
                <dict>
                  <key>name</key>
                  <string>Keyword</string>
                  <key>scope</key>
                  <string>keyword, storage</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>${pink}</string>
                  </dict>
                </dict>
                <dict>
                  <key>name</key>
                  <string>Operator</string>
                  <key>scope</key>
                  <string>keyword.operator</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>${light-pink}</string>
                  </dict>
                </dict>
                <dict>
                  <key>name</key>
                  <string>Module/Namespace</string>
                  <key>scope</key>
                  <string>entity.name.namespace, entity.name.module, support.other.namespace</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>${light-pink}</string>
                  </dict>
                </dict>
                <dict>
                  <key>name</key>
                  <string>Default</string>
                  <key>scope</key>
                  <string>variable, entity.name.function, entity.name.class, entity.name.type, support.type, support.class, meta.function-call, punctuation, constant, constant.numeric, constant.language, constant.character, constant.other</string>
                  <key>settings</key>
                  <dict>
                    <key>foreground</key>
                    <string>${fg}</string>
                  </dict>
                </dict>
              </array>
            </dict>
            </plist>
          '';
        };
        zellij.themes.agatha = ''
          themes {
          agatha {
          text_unselected {
            base ${hexToRgb fg}
            background ${hexToRgb bg}
            emphasis_0 ${hexToRgb pink}
            emphasis_1 ${hexToRgb cyan}
            emphasis_2 ${hexToRgb green}
            emphasis_3 ${hexToRgb magenta}
          }
          text_selected {
            base ${hexToRgb fg}
            background ${hexToRgb bg1}
            emphasis_0 ${hexToRgb pink}
            emphasis_1 ${hexToRgb cyan}
            emphasis_2 ${hexToRgb green}
            emphasis_3 ${hexToRgb magenta}
          }
          ribbon_selected {
            base ${hexToRgb bg}
            background ${hexToRgb pink}
            emphasis_0 ${hexToRgb red}
            emphasis_1 ${hexToRgb yellow}
            emphasis_2 ${hexToRgb magenta}
            emphasis_3 ${hexToRgb blue}
          }
          ribbon_unselected {
            base ${hexToRgb bg}
            background ${hexToRgb grey}
            emphasis_0 ${hexToRgb red}
            emphasis_1 ${hexToRgb fg}
            emphasis_2 ${hexToRgb blue}
            emphasis_3 ${hexToRgb magenta}
          }
          table_title {
            base ${hexToRgb pink}
            background 0
            emphasis_0 ${hexToRgb yellow}
            emphasis_1 ${hexToRgb cyan}
            emphasis_2 ${hexToRgb green}
            emphasis_3 ${hexToRgb magenta}
          }
          table_cell_selected {
            base ${hexToRgb fg}
            background ${hexToRgb bg2}
            emphasis_0 ${hexToRgb pink}
            emphasis_1 ${hexToRgb cyan}
            emphasis_2 ${hexToRgb green}
            emphasis_3 ${hexToRgb magenta}
          }
          table_cell_unselected {
            base ${hexToRgb fg}
            background ${hexToRgb bg}
            emphasis_0 ${hexToRgb pink}
            emphasis_1 ${hexToRgb cyan}
            emphasis_2 ${hexToRgb green}
            emphasis_3 ${hexToRgb magenta}
          }
          list_selected {
            base ${hexToRgb fg}
            background ${hexToRgb bg2}
            emphasis_0 ${hexToRgb pink}
            emphasis_1 ${hexToRgb cyan}
            emphasis_2 ${hexToRgb green}
            emphasis_3 ${hexToRgb magenta}
          }
          list_unselected {
            base ${hexToRgb fg}
            background ${hexToRgb bg}
            emphasis_0 ${hexToRgb pink}
            emphasis_1 ${hexToRgb cyan}
            emphasis_2 ${hexToRgb green}
            emphasis_3 ${hexToRgb magenta}
          }
          frame_selected {
            base ${hexToRgb pink}
            background 0
            emphasis_0 ${hexToRgb yellow}
            emphasis_1 ${hexToRgb cyan}
            emphasis_2 ${hexToRgb magenta}
            emphasis_3 0
          }
          frame_highlight {
            base ${hexToRgb light-pink}
            background 0
            emphasis_0 ${hexToRgb magenta}
            emphasis_1 ${hexToRgb pink}
            emphasis_2 ${hexToRgb pink}
            emphasis_3 ${hexToRgb pink}
          }
          exit_code_success {
            base ${hexToRgb green}
            background 0
            emphasis_0 ${hexToRgb cyan}
            emphasis_1 ${hexToRgb bg}
            emphasis_2 ${hexToRgb magenta}
            emphasis_3 ${hexToRgb blue}
          }
          exit_code_error {
            base ${hexToRgb red}
            background 0
            emphasis_0 ${hexToRgb yellow}
            emphasis_1 0
            emphasis_2 0
            emphasis_3 0
          }
          multiplayer_user_colors {
            player_1 ${hexToRgb magenta}
            player_2 ${hexToRgb blue}
            player_3 ${hexToRgb green}
            player_4 ${hexToRgb yellow}
            player_5 ${hexToRgb cyan}
            player_6 ${hexToRgb pink}
            player_7 ${hexToRgb red}
            player_8 ${hexToRgb light-pink}
            player_9 0
            player_10 0
          }
          }
          }
        '';
      };
    }
  ];
}
