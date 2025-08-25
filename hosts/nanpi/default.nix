{
  self,
  config,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    ./notifier.nix
    self.nixosModules.locale-en-gb
    self.diskoConfigurations.luks-btrfs-subvolumes
  ];

  networking.hostName = "nanpi";
  system.stateVersion = "25.05";
  time.timeZone = "America/Sao_Paulo";
  myHardware.acer.aspire."A315-53".enable = true;

  myNixOS = {
    programs = {
      lanzaboote.enable = true;
      nix.enable = true;
    };
    profiles = {
      base.enable = true;
      server.enable = true;
      autoUpgrade = {
        enable = true;
        operation = "boot";
        allowReboot = false;
      };
      backups.enable = true;
      btrfs = {
        enable = true;
        deduplicate = true;
      };
      swap = {
        enable = true;
        size = 4096;
        location = "/.swap";
      };
      arr.enable = true;
    };
    services = {
      audiobookshelf.enable = true;
      caddy.enable = true;
      cloudflared.enable = true;
      copyparty.enable = true;
      dnsmasq.enable = true;
      forgejo = {
        enable = true;
        db = "postgresql";
      };
      glance.enable = true;
      jellyfin.enable = true;
      jellyseerr.enable = true;
      karakeep.enable = true;
      miniflux.enable = true;
      ntfy.enable = true;
      pds.enable = true;
      qbittorrent = {
        enable = true;
        webuiPort = config.mySnippets.tailnet.networkMap.qbittorrent.port;
        openFirewall = true;
      };
      radicale.enable = true;
      redlib.enable = true;
      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        user = "ayla";
      };
      tailscale = {
        enable = true;
        enableCaddy = true;
        operator = "ayla";
      };
      vaultwarden.enable = true;
      webdav.enable = true;
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
