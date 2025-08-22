{
  lib,
  config,
  ...
}: {
  options.myHome.programs.zen-browser = {
    enable = lib.mkEnableOption "zen web browser";
  };

  config.programs.zen-browser =
    lib.mkIf config.myHome.programs.zen-browser.enable
    config.mySnippets.firefox-based.userConfig;
}
