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
          path = "/data/Backups";
        };

        "Books" = {
          devices = [
            "morgana"
            "m23"
          ];

          id = "1pnmb-naasx";
          path = "/data/Books";
        };

        "DCIM" = {
          devices = [
            "morgana"
            "m23"
            "nanpi"
          ];

          id = "dcfsw-meuwf";
          path = "/data/DCIM";
        };

        "Music" = {
          devices = [
            "morgana"
            "m23"
            "nanpi"
          ];

          id = "pacgr-fvsd7";
          path = "/data/Music";
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
          path = "/data/Pictures";
        };

        "Koreader Settings" = {
          devices = [
            "morgana"
            "m23"
          ];

          id = "hkw65-lktvx";
          path = "/data/Koreader";
        };

        "Obsidian" = {
          devices = [
            "morgana"
            "m23"
            "nanpi"
          ];

          id = "obsidian";
          path = "/home/ayla/Documents/Obsidian";
        };

        "Phone ROMs" = {
          devices = [
            "morgana"
            "m23"
          ];

          id = "2jcyv-esxcu";
          path = "/data/Phone ROMs";
        };

        "RetroArch Saves" = {
          devices = [
            "morgana"
            "m23"
          ];

          id = "guhfs-4e5qf";
          path = "/home/ayla/.var/app/org.libretro.RetroArch/config/retroarch/saves";
        };
      };
    };
  };
}
