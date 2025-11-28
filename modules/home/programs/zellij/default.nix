{
  lib,
  config,
  pkgs,
  ...
}: let
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

  broot_config = pkgs.writeText "broot-conf.toml" ''
    icon_theme = "nerdfont"
    modal = true
    initial_mode = "command"
    default_flags = "-gihc :sort_by_type;:watch"
    show_selection_mark = false
    cols_order = ["branch", "name", "git"]

    [skin]
    default = "none"

    [[verbs]]
    key = "n"
    execution = ":parent"

    [[verbs]]
    key = "e"
    execution = ":line_down"

    [[verbs]]
    key = "i"
    execution = ":line_up"

    [[verbs]]
    invocation = "edit"
    keys = [ "enter", "o" ]
    shortcut = "o"
    external = [ "${lib.getExe pkgs.bash}", "-e", "${lib.getExe broot-opener}", "{file}" ]
    apply_to = "text_file"
    leave_broot = false

    [[verbs]]
    key = "o"
    execution = ":open_stay"

    [special-paths]
    ".git" = { show = "never" }
    ".jj" = { show = "never" }
    "result" = { show = "never" }
    "node_modules" = { list = "never", sum = "never" }
    "build" = { list = "never", sum = "never" }
    "dist" = { list = "never", sum = "never" }
    ".zed" = { list = "never", sum = "never" }
    ".helix" = { list = "never", sum = "never" }
    ".github" = { list = "never", sum = "never" }
    ".vscode" = { list = "never", sum = "never" }
  '';

  helix_config_raw = builtins.readFile ./helix.kdl;
  helix_config =
    builtins.replaceStrings
    ["__BROOT_CONFIG__"]
    ["${broot_config}"]
    helix_config_raw;
in {
  options.myHome.programs.zellij.enable = lib.mkEnableOption "zellij";

  config = lib.mkIf config.myHome.programs.zellij.enable {
    programs.zellij = {
      enable = true;
      enableFishIntegration = false;
      settings = {
        theme = "onedark";
        default_shell = "fish";
        show_startup_tips = false;
        pane_frames = false;
        default_layout = "compact";
        keybinds = {unbind = "Ctrl q";};
        ui = {pane_frames = {rounded_corners = true;};};
      };
      layouts = {helix = helix_config;};
      extraConfig = builtins.readFile ./zellij.kdl;
    };
  };
}
