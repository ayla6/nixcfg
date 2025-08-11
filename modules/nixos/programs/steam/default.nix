{
  config,
  lib,
  ...
}: {
  options.myNixOS.programs.steam.enable = lib.mkEnableOption "the game launcher that sucks";

  config = lib.mkIf config.myNixOS.programs.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };
}
