# this config wouldn't work properly on newer intel gpus
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHardware.intel.gpu.enable = lib.mkEnableOption "Intel GPU configuration.";

  config = lib.mkIf config.myHardware.intel.gpu.enable {
    boot = {
      initrd.kernelModules = ["i915"];
      kernelParams = ["i915.enable_guc=3"];
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
      VDPAU_DRIVER = "va_gl";
    };

    hardware = {
      intel-gpu-tools.enable = true;

      graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = with pkgs; [
          intel-media-driver # LIBVA_DRIVER_NAME=iHD
          (intel-vaapi-driver.override {enableHybridCodec = true;})
          libvdpau-va-gl
          vpl-gpu-rt
          intel-compute-runtime-legacy1
        ];

        extraPackages32 = [
          pkgs.driversi686Linux.intel-media-driver # LIBVA_DRIVER_NAME=iHD
          (pkgs.driversi686Linux.intel-vaapi-driver.override {enableHybridCodec = true;})
          pkgs.driversi686Linux.libvdpau-va-gl
        ];
      };

      enableRedistributableFirmware = true;
    };

    services.xserver.videoDrivers = ["modesetting"];
  };
}
