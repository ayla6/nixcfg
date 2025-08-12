{
  self,
  config,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    ./services.nix
    self.nixosModules.locale-en-gb
    self.diskoConfigurations.lvm-ext4
  ];

  networking.hostName = "nanpi";
  system.stateVersion = "25.05";
  time.timeZone = "America/Sao_Paulo";
  myHardware.hp.theRedOne.enable = true;

  myNixOS = {
    programs = {
      systemd-boot.enable = true;
      nix.enable = true;
    };
    profiles = {
      base.enable = true;
      server.enable = true;
      autoUpgrade = {
        enable = true;
        operation = "boot";
      };
      backups.enable = true;
    };
    services = {
      caddy.enable = true;
      tailscale = {
        enable = true;
        enableCaddy = false;
        operator = "ayla";
      };
      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        user = "ayla";
      };
      qbittorrent = {
        inherit (config.mySnippets.tailnet.networkMap.qbittorrent) port;
        enable = true;
      };
    };
  };

  myUsers = {
    ayla = {
      enable = true;
      password = "REDACTED";
    };
  };

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
    };

    kernelParams = [
      "consoleblank=30"
    ];
  };
}
