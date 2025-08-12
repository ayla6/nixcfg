{lib, ...}: {
  options = {
    mySnippets.syncthing.folders = lib.mkOption {
      description = "List of Syncthing folders.";
      type = lib.types.attrs;

      default = {
        "Backups" = {
          devices = [
            "morgana"
            "m23"
          ];

          id = "cerbn-dj3xo";
          path = "~/Backups";
        };

        "Books" = {
          devices = [
            "morgana"
            "m23"
          ];

          id = "1pnmb-naasx";
          path = "/home/Data/Books";
        };

        "DCIM" = {
          devices = [
            "morgana"
            "m23"
          ];

          id = "dcfsw-meuwf";
          path = "~/DCIM";
        };

        "Music" = {
          devices = [
            "morgana"
            "m23"
          ];

          id = "pacgr-fvsd7";
          path = "~/Music";
        };

        "Passwords" = {
          devices = [
            "morgana"
            "m23"
          ];

          id = "mkiff-evvnj";
          path = "~/Documents/Passwords";
        };

        "Pictures" = {
          devices = [
            "morgana"
            "m23"
          ];

          id = "u5d66-bcnho";
          path = "~/Pictures";
        };

        "Koreader Settings" = {
          devices = [
            "morgana"
            "m23"
          ];

          id = "hkw65-lktvx";
          path = "/home/Data/koreader";
        };
      };
    };
  };
}
