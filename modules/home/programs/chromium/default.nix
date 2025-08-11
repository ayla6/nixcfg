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

        rec {
          id = "libredirectlibredirectlibredirec"; # libredirect
          version = "3.2.0";

          crxPath = pkgs.fetchurl {
            url = "https://github.com/libredirect/browser_extension/releases/download/v${version}/libredirect-${version}.crx";
            sha256 = "sha256-Neja0pJ7rMV+riINeMcWxU2SzZ+ZETp6bV1MaYLHz1Y=";
          };
        }
      ];

      package =
        if pkgs.stdenv.isDarwin
        then (pkgs.runCommand "chromium-0.0.0" {} "mkdir $out")
        else pkgs.ungoogled-chromium;
    };
  };
}
