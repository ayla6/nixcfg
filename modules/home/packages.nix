{pkgs, ...}: {
  home.packages = with pkgs; [
    # --- System Utilities ---
    zip
    xz
    unzip
    p7zip
  ];
}
