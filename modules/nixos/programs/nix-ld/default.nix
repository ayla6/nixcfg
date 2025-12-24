{
  pkgs,
  lib,
  config,
  ...
}: let
  pkgsFlac8 = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/c2c0373ae7abf25b7d69b2df05d3ef8014459ea3.tar.gz";
    sha256 = "sha256:19a98q762lx48gxqgp54f5chcbq4cpbq85lcinpd0gh944qindmm";
  }) {inherit (pkgs.stdenv.hostPlatform) system;};
in {
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
        nss
        nspr

        # for games like crypt of the necrodancer
        pkgsFlac8.flac
        (pkgs.runCommand "steamrun-lib" {} "mkdir $out; ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib")
      ];
    };
  };
}
