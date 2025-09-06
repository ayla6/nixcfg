# https://github.com/isabelroses/dotfiles/blob/ed6d3765ffb7dcfe67540f111f23d51a0d9617d5/modules/home/programs/chromium.nix#L16
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit
    (lib)
    concatLists
    enableFeature
    ;
in {
  options.myHome.programs.helium.enable = lib.mkEnableOption "helium web browser";

  config = lib.mkIf config.myHome.programs.helium.enable {
    programs.helium = {
      enable = true;

      extensions = [
        {id = "mdjildafknihdffpkfmmpnpoiajfjnjd";} # consent-o-matic
        {id = "clngdbkpkpeebahjckkjfobafhncgmne";} # stylus
        {id = "jinjaccalgkegednnccohejagnlnfdag";} # violentmonkey
        {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden
        {id = "mnjggcdmjocbbbhaepdhchncahnbgone";} # sponsorblock
        {id = "pncfbmialoiaghdehhbnbhkkgmjanfhe";} # ublacklist

        rec {
          id = "oladmjdebphlnjjcnomfhhbfdldiimaf"; # libredirect
          version = "3.2.0";

          crxPath = pkgs.fetchurl {
            url = "https://github.com/libredirect/browser_extension/releases/download/v${version}/libredirect-${version}.crx";
            sha256 = "sha256-Neja0pJ7rMV+riINeMcWxU2SzZ+ZETp6bV1MaYLHz1Y=";
          };
        }

        rec {
          id = "lkbebcjgcmobigpeffafkodonchffocl"; # bypass-paywalls-clean
          version = "4.2.0.0";

          crxPath = pkgs.fetchurl {
            url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass-paywalls-chrome-clean-${version}.crx";
            sha256 = "sha256-B++3RussuUv3AtDi2MnZH+SojCPOMnOXWW8GI3pI8lk=";
          };
        }
      ];

      package = pkgs.helium.override {
        # https://github.com/secureblue/hardened-chromium
        # https://github.com/secureblue/secureblue/blob/e500f078efc5748d5033a881bbbcdcd2de95a813/files/system/usr/etc/chromium/chromium.conf.md
        commandLineArgs = concatLists [
          # Aesthetics
          [
            "--gtk-version=4"
          ]

          # Wayland
          [
            "--ozone-platform=wayland"
            "--enable-features=UseOzonePlatform"
          ]

          # Performance
          [
            (enableFeature true "gpu-rasterization")
            (enableFeature true "oop-rasterization")
            (enableFeature true "zero-copy")
            "--ignore-gpu-blocklist"
          ]

          # Etc
          [
            "--disk-cache=$XDG_RUNTIME_DIR/helium-cache"
            (enableFeature false "reading-from-canvas")
            "--no-first-run"
            "--disable-wake-on-wifi"
            "--disable-breakpad"
            "--no-default-browser-check"
            "--enable-features=TouchpadOverscrollHistoryNavigation"
          ]
        ];
      };
    };
  };
}
