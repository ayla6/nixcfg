{
  self,
  modulesPath,
  ...
}: {
  imports = [
    ./secrets.nix
    self.nixosModules.locale-en-gb
    "${modulesPath}/profiles/qemu-guest.nix"
    self.diskoConfigurations.btrfs-vps
  ];

  networking = {
    firewall.allowedTCPPorts = [80 443];
    hostName = "jezebel";
  };
  system.stateVersion = "25.05";
  time.timeZone = "America/Sao_Paulo";
  nixpkgs.hostPlatform = "x86_64-linux";

  myNixOS = {
    programs = {
      nix.enable = true;
    };
    profiles = {
      base.enable = true;
      btrfs = {
        enable = true;
        deduplicate = true;
      };
      server.enable = true;
      backups.enable = true;
      vps.enable = true;
      autoUpgrade = {
        enable = true;
        operation = "switch";
      };
      swap = {
        enable = true;
        size = 2048;
      };
    };
    services = {
      caddy.enable = true;
      dnsmasq.enable = true;
      tailscale = {
        enable = true;
        enableCaddy = true;
      };
      tangled-knot.enable = true;
      uptime-kuma.enable = true;
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "contact@aylac.top";
  };
}
