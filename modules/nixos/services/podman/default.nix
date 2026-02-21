{
  config,
  lib,
  ...
}: {
  options.myNixOS.services.podman = {
    enable = lib.mkEnableOption "enable podman";
  };

  config = lib.mkIf config.myNixOS.services.podman.enable {
    virtualisation = {
      containers.enable = true;

      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = false;
        autoPrune = {
          enable = true;
          flags = ["--all"];
        };
      };

      oci-containers.backend = "podman";
    };
  };
}
