{
  config,
  lib,
  ...
}: let
  functions_folder = ./functions;

  functions = builtins.attrNames (
    lib.filterAttrs (name: type: type == "regular" && lib.strings.hasSuffix ".fish" name) (builtins.readDir functions_folder)
  );
in {
  options.myHome.programs.fish.enable = lib.mkEnableOption "fish config";

  config = lib.mkIf config.myHome.programs.fish.enable {
    programs.fish = {
      enable = true;
      interactiveShellInit = ''
        set -gx PATH $PATH /home/$USER/.local/bin
      '';
    };
    xdg.configFile = lib.listToAttrs (
      map (file_name: {
        name = "fish/functions/${file_name}";
        value.source = functions_folder + "/${file_name}";
      })
      functions
    );
  };
}
