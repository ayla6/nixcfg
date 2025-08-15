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
            "nanpi"
          ];

          id = "cerbn-dj3xo";
          path = "/home/ayla/Backups";
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
            "nanpi"
          ];

          id = "dcfsw-meuwf";
          path = "/home/ayla/DCIM";
        };

        "Music" = {
          devices = [
            "morgana"
            "m23"
          ];

          id = "pacgr-fvsd7";
          path = "/home/ayla/Music";
        };

        "Passwords" = {
          devices = [
            "morgana"
            "m23"
            "nanpi"
          ];

          id = "mkiff-evvnj";
          path = "/home/ayla/Documents/Passwords";
        };

        "Pictures" = {
          devices = [
            "morgana"
            "m23"
            "nanpi"
          ];

          id = "u5d66-bcnho";
          path = "/home/ayla/Pictures";
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
