{
  self,
  config,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
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
    style.fonts.enable = true;
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

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/8ed468ba-610b-49c8-8b93-5a20d4bf14da";
      fsType = "btrfs";
      options = [
        "subvol=@"
        "compress=zstd"
        "noatime"
      ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/4831-1B0D";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    "/home/Data" = {
      device = "/dev/disk/by-uuid/6cfb1f47-51d6-4ece-ab1c-6ad3c2d41542";
      fsType = "ext4";
    };
  };
}
