{
  self,
  config,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    ./notifier.nix
    ./backups.nix
    self.nixosModules.locale-en-gb
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
      audiobookshelf.enable = false;
      caddy.enable = true;
      cloudflared.enable = true;
      copyparty.enable = false;
      dnsmasq.enable = true;
      forgejo.enable = true;
      glance.enable = true;
      jellyfin.enable = true;
      jellyseerr.enable = true;
      karakeep.enable = false;
      miniflux.enable = true;
      ntfy.enable = true;
      pds.enable = true;
      privatebin.enable = true;
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
      tangled-knot.enable = true;
    };
  };

  myUsers = {
    ayla = {
      enable = true;
      passwordFile = config.age.secrets.aylaPassword.path;
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

      luks.devices = {
        crypted.device = "/dev/disk/by-uuid/d82fc855-f29a-4aef-90d4-da94c23d0ac1";
        crypted_external.device = "/dev/disk/by-uuid/0e477648-92d6-4cf5-a0c5-8d0707b69935";
      };
    };

    kernelParams = [
      "consoleblank=30"
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/97fd311a-2575-487e-be03-45dfa9c2db8a";
      fsType = "btrfs";
      options = ["subvol=/root" "compress=zstd" "noatime"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/97fd311a-2575-487e-be03-45dfa9c2db8a";
      fsType = "btrfs";
      options = ["subvol=/home" "compress=zstd" "noatime"];
    };

    "/home/.snapshots" = {
      device = "/dev/disk/by-uuid/97fd311a-2575-487e-be03-45dfa9c2db8a";
      fsType = "btrfs";
      options = ["subvol=/home/.snapshots" "compress=zstd" "noatime"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/97fd311a-2575-487e-be03-45dfa9c2db8a";
      fsType = "btrfs";
      options = ["subvol=/nix" "compress=zstd" "noatime"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/7D56-EE82";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    "/external1" = {
      device = "/dev/disk/by-uuid/130ead1c-6642-45d5-9053-b6cb2df9c7e4";
      fsType = "btrfs";
      options = ["compress=zstd" "noatime"];
    };
  };
}
