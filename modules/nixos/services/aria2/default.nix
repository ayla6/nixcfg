{
  pkgs,
  lib,
  config,
  ...
}: {
  options.myNixOS.services.aria2 = {
    enable = lib.mkEnableOption "Aria2 service";
  };

  config = lib.mkIf config.myNixOS.services.aria2.enable {
    systemd.user.services.aria2 = {
      description = "aria2 daemon";
      after = ["network.target"];
      wantedBy = ["default.target"];
      serviceConfig = {
        ExecStart = "${pkgs.aria2}/bin/aria2c --enable-rpc --rpc-listen-all --rpc-allow-origin-all --dir=%h/Downloads";
        Restart = "always";
        RestartSec = "10";
        Type = "forking";
        WorkingDirectory = "%h";
        Environment = "HOME=%h";
      };
    };
  };
}
