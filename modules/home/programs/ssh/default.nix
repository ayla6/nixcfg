{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.ssh.enable = lib.mkEnableOption "openssh client";

  config = lib.mkIf config.myHome.programs.ssh.enable {
    programs.ssh = {
      enable = true;
      compression = true;

      # matchBlocks = let
      #   rootMe = name: {
      #     ${name} = {
      #       hostname = name;
      #       user = "root";
      #     };
      #   };
      # in
      #   rootMe "dewford";

      package = pkgs.openssh;
    };
  };
}
