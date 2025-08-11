{
  pkgs,
  lib,
  config,
  ...
}: {
  options.myNixOS.programs.nix-ld.enable = lib.mkEnableOption "so you can run non nix apps!";

  config = lib.mkIf config.myNixOS.programs.nix.enable {
    # Enable nix-ld for running non-NixOS binaries like language servers
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        # Common libraries that might be needed by language servers
        stdenv.cc.cc
        openssl
        zlib
        curl
        glibc
        (pkgs.runCommand "steamrun-lib" {} "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")
      ];
    };
  };
}
