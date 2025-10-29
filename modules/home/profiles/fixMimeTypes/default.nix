{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.myHome.profiles.fixMimeTypes;

  xml = pkgs.formats.xml {};

  # thank you chatgpt ig
  makeMimeFile = {
    type, # e.g. "text/x-typescript"
    comment, # e.g. "TypeScript source file"
    globs, # list of patterns: [ "*.ts" "*.tsx" ]
  }:
    xml.generate (builtins.replaceStrings ["/"] ["_"] "${type}.xml") {
      "mime-info" = {
        "@xmlns" = "http://www.freedesktop.org/standards/shared-mime-info";
        "mime-type" = {
          "@type" = type;
          comment = comment;
          glob = map (pattern: {"@pattern" = pattern;}) globs;
        };
      };
    };
in {
  options.myHome.profiles.fixMimeTypes = {
    enable = lib.mkEnableOption "mimetypes are dumb and they don't always register the right formats";
  };

  config = lib.mkIf cfg.enable {
    xdg.dataFile = {
      "mime/packages/typescript-ts.xml".source = makeMimeFile {
        type = "text/x-typescript";
        comment = "TypeScript source file";
        globs = ["*.ts" "*.tsx"];
      };

      "mime/packages/svelte.xml".source = makeMimeFile {
        type = "text/x-svelte";
        comment = "Svelte source file";
        globs = ["*.svelte" "*.svelte.ts" "*.svelte.js"];
      };
    };
  };
}
