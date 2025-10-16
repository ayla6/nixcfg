{
  self,
  config,
  ...
}: {
  imports = [
    ./home.nix
    ./secrets.nix
    self.nixosModules.locale-en-ca
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
    };
    profiles = {
      base.enable = true;
      workstation.enable = true;

      btrfs = {
        enable = true;
        deduplicate = true;
        snapshots = true;
      };
      tmpOnTmpfs.enable = true;
    };
    desktop.gnome.enable = true;
    services = {
      dnsmasq = {
        enable = true;
        longCaches = false;
      };
      flatpak.enable = true;
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
    };
  };

  myUsers = {
    ayla = {
      enable = true;
      passwordFile = config.age.secrets.aylaPassword.path;
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

    luks.devices = {
      crypted1.device = "/dev/disk/by-uuid/796c4c65-22b9-40e2-a928-66d20d528330";
      crypted2.device = "/dev/disk/by-uuid/7665834d-1f38-4c1e-9b44-449ea8fc055c";
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/e88969b5-98a0-4d46-a059-8e07ebf2689e";
      fsType = "btrfs";
      options = ["subvol=@" "compress=zstd" "noatime"];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/e88969b5-98a0-4d46-a059-8e07ebf2689e";
      fsType = "btrfs";
      options = ["subvol=@home" "compress=zstd" "noatime"];
    };

    "/home/.snapshots" = {
      device = "/dev/disk/by-uuid/e88969b5-98a0-4d46-a059-8e07ebf2689e";
      fsType = "btrfs";
      options = ["subvol=.snapshots" "compress=zstd" "noatime"];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/e88969b5-98a0-4d46-a059-8e07ebf2689e";
      fsType = "btrfs";
      options = ["subvol=@nix" "compress=zstd" "noatime"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/0CC3-3395";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };

    "/data" = {
      device = "/dev/disk/by-uuid/e5cf35fa-55bc-499f-a39b-e844a442e0f0";
      fsType = "btrfs";
      options = ["subvol=@data" "compress=zstd" "noatime"];
    };
  };

  # samba for ps2 opl
  services.samba = {
    enable = true;
    openFirewall = true;
    winbindd.enable = false;
    nmbd.enable = false;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";

        "bind interfaces only" = "yes";
        "interfaces" = "lo enp2s0f1";

        "client min protocol" = "CORE";
        "client max protocol" = "NT1";
        "server max protocol" = "SMB3";
        "server min protocol" = "LANMAN1";
        "strict sync" = "no";
        "keepalive" = "0";

        "getwd cache" = "yes";
        "large readwrite" = "yes";
        "aio read size" = "0";
        "aio write size" = "0";
        "strict locking" = "no";
        "strict allocate" = "no";
        "read raw" = "no";
        "write raw" = "no";

        "server signing" = "disabled";
        "smb encrypt" = "disabled";
        "socket options" = "TCP_NODELAY IPTOS_LOWDELAY SO_KEEPALIVE";

        "load printers" = "no";
        "disable spoolss" = "yes";

        "map to guest" = "bad user";

        "available" = "yes";
        "create mask" = "0777";
        "directory mask" = "0777";
        "force user" = "ayla";
        "force group" = "users";
      };
      "PS2SMB" = {
        "comment" = "PS2 SMB";
        "path" = "/data/PS2SMB";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "public" = "yes";
        "strict sync" = "no";
      };
    };
  };
}
