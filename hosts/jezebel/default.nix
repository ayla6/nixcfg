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

  networking.hostName = "jezebel";
  system.stateVersion = "25.05";
  time.timeZone = "America/Sao_Paulo";
  nixpkgs.hostPlatform = "x86_64-linux";

  myNixOS = {
    programs = {
      nix.enable = true;
    };
    profiles = {
      base.enable = true;
      btrfs.enable = true;
      server.enable = true;
      autoUpgrade = {
        enable = true;
        operation = "switch";
      };
    };
    services = {
      caddy.enable = true;
      tailscale = {
        enable = true;
        enableCaddy = true;
      };
    };
  };

  services = {
    qemuGuest.enable = true;
    spice-vdagentd.enable = true;
  };

  boot = {
    loader.grub = {
      enable = true;
    };
    initrd = {
      availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod"];
      kernelModules = [];
    };
    kernelModules = [""];
    extraModulePackages = [];
  };
}
