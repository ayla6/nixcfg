{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myNixOS.programs.lanzaboote.enable = lib.mkEnableOption "secure boot with lanzaboote";

  config = lib.mkIf config.myNixOS.programs.lanzaboote.enable {
    boot = {
      initrd.systemd.enable = true;

      lanzaboote = {
        enable = true;
        configurationLimit = 10;
        pkiBundle = lib.mkDefault "/var/lib/sbctl";
        sortKey = "lanza";
        settings = {
          inherit (config.boot.loader) timeout;
        };
      };

      loader = {
        systemd-boot.enable = lib.mkForce false;
        timeout = lib.mkDefault 5;
      };
    };

    environment.systemPackages = [pkgs.sbctl];
  };
}
