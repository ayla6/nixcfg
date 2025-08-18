{
  config,
  lib,
  pkgs,
  ...
}: {
  options.myHome.programs.chromium.enable = lib.mkEnableOption "chromium web browser";

  config = lib.mkIf config.myHome.programs.chromium.enable {
    programs.chromium = {
      enable = true;

      extensions = [
        {id = "ddkjiahejlhfcafbddmgiahcphecmpfh";} # ublock origin lite
        {id = "mdjildafknihdffpkfmmpnpoiajfjnjd";} # consent-o-matic
        {id = "clngdbkpkpeebahjckkjfobafhncgmne";} # stylus
        {id = "oboonakemofpalcgghocfoadofidjkkk";} # keepassxc
        {id = "jinjaccalgkegednnccohejagnlnfdag";} # violentmonkey
        {id = "nngceckbapebfimnlniiiahkandclblb";} # bitwarden

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
          version = "4.1.8.0";

          crxPath = pkgs.fetchurl {
            url = "https://gitflic.ru/project/magnolia1234/bpc_uploads/blob/raw?file=bypass-paywalls-chrome-clean-${version}.crx";
            sha256 = "sha256-BRpwrV8AN1eOG2IXfk24gyEd8OzwK1BJqDdoxlgX8o4=";
          };
        }
      ];

      package =
        if pkgs.stdenv.isDarwin
        then (pkgs.runCommand "chromium-0.0.0" {} "mkdir $out")
        # else pkgs.chromium;
        else pkgs.ungoogled-chromium;

      commandLineArgs = lib.mkIf pkgs.stdenv.isLinux [
        "--enable-features=TouchpadOverscrollHistoryNavigation"
        "--gtk-version=4"
      ];
    };
  };
}
