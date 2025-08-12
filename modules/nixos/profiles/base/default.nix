{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.profiles.base.enable = lib.mkEnableOption "base system configuration";

  config = lib.mkIf config.myNixOS.profiles.base.enable {
    environment = {
      etc."nixos".source = self;

      systemPackages = with pkgs; [
        (lib.hiPrio uutils-coreutils-noprefix)
        wget
        micro
        git
        wget
        btop
      ];
    };

    programs = {
      dconf.enable = true; # Needed for home-manager

      direnv = {
        enable = true;
        nix-direnv.enable = true;
        silent = true;
      };

      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

      nh.enable = true;
      ssh.knownHosts = config.mySnippets.ssh.knownHosts;
    };

    networking.networkmanager.enable = true;

    security = {
      polkit.enable = true;
      rtkit.enable = true;

      sudo-rs = {
        enable = true;
        wheelNeedsPassword = false;
      };
    };

    services = {
      cachefilesd = {
        enable = true;

        extraConfig = ''
          brun 20%
          bcull 10%
          bstop 5%
        '';
      };

      openssh = {
        enable = true;
        openFirewall = true;
        settings = {
          PasswordAuthentication = false;
          PubkeyAuthentication = true;
        };
      };
    };

    system = {
      configurationRevision = self.rev or self.dirtyRev or null;
      nixos.tags = ["base"];
      rebuild.enableNg = true;
    };
  };
}
