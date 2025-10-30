{
  pkgs,
  lib,
  config,
  ...
}: {
  options.myNixOS.desktop.plasma.enable = lib.mkEnableOption "use kde plasma desktop environment";

  config = lib.mkIf config.myNixOS.desktop.plasma.enable {
    home-manager.sharedModules = [
      {
        config.myHome.desktop.plasma.enable = true;
      }
    ];

    environment.plasma6.excludePackages = with pkgs; [
      kdePackages.kwallet
      kdePackages.kwallet-pam
      kdePackages.kwalletmanager
      kdePackages.wacomtablet
    ];

    services.desktopManager.plasma6.enable = true;
    system.nixos.tags = ["plasma"];
    myNixOS.desktop.enable = true;
  };
}
