{
  self,
  config,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    ./disko.nix
    self.nixosModules.locale-en-gb
  ];

  networking.hostName = "morgana";
  system.stateVersion = "25.05";
  time.timeZone = "America/Sao_Paulo";
  myHardware.acer.aspire.A515-52G.enable = true;

  myNixOS = {
    programs = {
      lanzaboote.enable = true;
      nix.enable = true;
      nix-ld.enable = true;
      steam.enable = true;
      firefox.enable = true;
    };
    profiles = {
      base.enable = true;
      workstation.enable = true;
      btrfs.enable = true;
      autoUpgrade = {
        enable = true;
        operation = "switch";
      };
      tmpOnTmpfs.enable = true;
    };
    desktop.gnome.enable = true;
    services = {
      # i can't make caddy work :(
      #caddy.enable = true;
      tailscale = {
        enable = true;
        # i can't make caddy work :(
        enableCaddy = false;
        operator = "ayla";
      };
      aria2.enable = true;
      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        user = "ayla";
      };
    };
  };

  myUsers = {
    ayla = {
      enable = true;
      password = "REDACTED";
    };
  };

  boot.initrd = {
    availableKernelModules = [
      "xhci_pci"
      "ahci"
      "usb_storage"
      "sd_mod"
      "rtsx_pci_sdmmc"
    ];

    luks.devices."luks-cc030211-13e5-4411-a906-94c6ef45a0c6".device = "/dev/disk/by-uuid/cc030211-13e5-4411-a906-94c6ef45a0c6";
  };
}
