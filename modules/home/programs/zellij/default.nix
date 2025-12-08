{
  lib,
  config,
  pkgs,
  ...
}: let
  helix_opener = pkgs.writeShellApplication {
    name = "hx_opener";
    text = ''
      # Make sure we are focused on helix
      zellij action go-to-tab-name "main"
      zellij action write 27 # escape
      zellij action write-chars ":open $1"
      zellij action write 13 # enter
    '';
  };

  yazi_wrapper = pkgs.writeShellScriptBin "yazi_wrapper" ''
    export EDITOR="${lib.getExe helix_opener}"
    exec ${lib.getExe config.programs.yazi.finalPackage} "$@"
  '';

  helix_config_raw = builtins.readFile ./helix.kdl;
  helix_config =
    builtins.replaceStrings
    ["__YAZI__"]
    ["${lib.getExe yazi_wrapper}"]
    helix_config_raw;
in {
  options.myHome.programs.zellij.enable = lib.mkEnableOption "zellij";

  config = lib.mkIf config.myHome.programs.zellij.enable {
    programs.zellij = {
      enable = true;
      enableFishIntegration = false;
      settings = {
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
