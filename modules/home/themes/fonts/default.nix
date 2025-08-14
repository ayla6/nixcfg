{
  lib,
  config,
  self,
  ...
}: let
  fontSourceDir = self + "/secrets/fonts";

  # Calculate the destination directory relative to home (e.g., ".local/share/fonts").
  fontTargetDir = lib.removePrefix (config.home.homeDirectory + "/") (config.xdg.dataHome + "/fonts");

  # A helper function to recursively find all file paths in a directory.
  # This approach avoids Nix's string "tainting" issue.
  findFilesRecursive = dir: let
    entries = builtins.readDir dir;
    processEntry = name: type: let
      path = dir + "/${name}";
    in
      if type == "regular"
      then [name]
      else if type == "directory"
      then map (sub: "${name}/${sub}") (findFilesRecursive path)
      else [];
  in
    lib.flatten (lib.mapAttrsToList processEntry entries);

  # Build the final attribute set for `home.file`.
  fontFileEntries = lib.listToAttrs (
    map (relativePath: {
      name = "${fontTargetDir}/${relativePath}";
      value.source = fontSourceDir + "/${relativePath}";
    }) (findFilesRecursive fontSourceDir)
  );
in {
  options.myHome.themes.fonts.enable = lib.mkEnableOption "custom fonts";

  config = lib.mkIf config.myHome.themes.fonts.enable {
    home.file = fontFileEntries;
  };
}
