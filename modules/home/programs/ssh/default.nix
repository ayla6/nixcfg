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

      # matchBlocks = let
      #   rootMe = name: {
      #     ${name} = {
      #       hostname = name;
      #       user = "root";
      #     };
      #   };
      # in
      #   rootMe "dewford";

      matchBlocks = {
        "knot.aylac.top" = {
          user = "git";
          # dont know if i can just link snippets knot here
          hostname = "nanpi";
          port = 2222;
        };
      };

      package = pkgs.openssh;
    };
  };
}
