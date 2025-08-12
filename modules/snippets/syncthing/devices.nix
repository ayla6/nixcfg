{lib, ...}: {
  options = {
    mySnippets.syncthing.devices = lib.mkOption {
      description = "List of Syncthing devices.";
      type = lib.types.attrs;

      default = {
        "m23" = {id = "EXW2FQP-LLGZTF3-UJ7IQ6D-CZB4UWB-ZQHM4GG-T6D4E2Q-ZOWSTG4-HJOKPQK";}; # Samsung Galaxy M23
        "morgana" = {id = "IR327YY-QZD7HZX-F24BWPO-UXQAVGU-4M2WN3P-XCYPCGX-ZQKDLIV-BL6RNAR";}; # Acer Aspire A515-52G
        "nanpi" = {id = "UBHN6T7-SLXLI4P-WVXQ35Q-OH4RPOI-RCVODK7-ASBJU6A-7BIEMYU-5ICYJAN";}; # The Red HP Laptop
      };
    };
  };
}
