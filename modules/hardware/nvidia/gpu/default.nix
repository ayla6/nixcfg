{
  config,
  lib,
  pkgs,
  ...
}: let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __VK_LAYER_NV_optimus=NVIDIA_only
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export DRI_PRIME=1 DXVK_NVAPIHACK=0
    export DXVK_ENABLE_NVAPI=1
    exec "$@"
  '';
in {
  options.myHardware.nvidia.gpu.enable = lib.mkEnableOption "Use the NVIDIA proprietary GPU drivers.";

  config = lib.mkIf config.myHardware.nvidia.gpu.enable {
    boot = {
      extraModulePackages = [config.boot.kernelPackages.nvidia_x11];
      kernelModules = ["nvidia"];
      kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
    };

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [
      "modesetting"
      "nvidia"
    ];

    environment.systemPackages = [
      nvidia-offload
    ];

    # Enable OpenGL
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };

      nvidia = {
        # Modesetting is required.
        modesetting.enable = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
        # of just the bare essentials.
        powerManagement.enable = false;

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of
        # supported GPUs is at:
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
        # Only available from driver 515.43.04+
        open = false;

        # Enable the Nvidia settings menu,
        # accessible via `nvidia-settings`.
        nvidiaSettings = true;

        # Optionally, you may need to select the appropriate driver version for your specific GPU.
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        prime.offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };
  };
}
