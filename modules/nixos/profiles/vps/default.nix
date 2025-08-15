{
  config,
  lib,
  ...
}: {
  options.myNixOS.profiles.vps.enable = lib.mkEnableOption "boot settings for vpses!";
  config = lib.mkIf config.myNixOS.profiles.vps.enable {
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
  };
}
