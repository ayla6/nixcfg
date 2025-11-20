# https://tangled.org/nel.pet/cyclamen/blob/main/modules/home/helix/default.nix
{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  # TODO: figure out something better than broot (probably self written). its close but not quite what i want and
  # configuring it is (evidently) a pain in the ass
  broot-opener = pkgs.writeShellApplication {
    name = "broot-zellij-hx-opener";
    text = ''
      # Make sure we are focused on helix
      zellij action go-to-tab-name "main"
      zellij action move-focus right
      zellij action move-focus up
      zellij action write 27 # escape
      zellij action write-chars ":open $1"
      zellij action write 13 # enter
    '';
  };
  broot-conf = pkgs.writeTextDir "brootconf/conf.toml" ''
    modal = true
    initial_mode = "command"

    default_flags = "-gihc :sort_by_type"

    [[verbs]]
    invocation = "edit"
    key = "enter"
    shortcut = "e"
    external = [ "${lib.getExe pkgs.bash}", "-e", "${lib.getExe broot-opener}", "{file}" ]
    apply_to = "text_file"
    leave_broot = false

    [special-paths]
    ".git" = { show = "never" }
    ".jj" = { show = "never" }
    "result" = { show = "never" }
  '';
  abaca-broot = inputs.wrappers.lib.wrapPackage {
    inherit pkgs;
    package = pkgs.broot;
    env = {
      BROOT_CONFIG_DIR = "${broot-conf}/brootconf";
    };
  };
  zellij-layout = pkgs.writeText "zellij-layout.kdl" ''
    layout {
        tab name="main" {
            pane split_direction="vertical" {
                pane name="sidebar" size=30 command="broot"
                pane name="helix" command="hx"
            }
            pane size=1 borderless=true {
                plugin location="compact-bar"
            }
        }
        tab name="term" {
            pane
            pane size=1 borderless=true {
                plugin location="compact-bar"
            }
        }
    }
  '';
  abaca = pkgs.writeShellApplication {
    name = "abaca";
    runtimeInputs = [config.programs.zellij.package config.programs.helix.package abaca-broot];
    text = ''
      exec ${lib.getExe pkgs.zellij} \
        "--layout" "${zellij-layout}" \
        "$@"
    '';
  };
in {
  config = lib.mkIf config.myHome.programs.helix.enable {
    home.packages = [
      abaca
    ];
  };
}
