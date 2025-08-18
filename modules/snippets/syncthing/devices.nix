{lib, ...}: {
  options = {
    mySnippets.syncthing.devices = lib.mkOption {
      description = "List of Syncthing devices.";
      type = lib.types.attrs;

      default = {
        "m23" = {id = "EXW2FQP-LLGZTF3-UJ7IQ6D-CZB4UWB-ZQHM4GG-T6D4E2Q-ZOWSTG4-HJOKPQK";}; # Samsung Galaxy M23
        "morgana" = {id = "IR327YY-QZD7HZX-F24BWPO-UXQAVGU-4M2WN3P-XCYPCGX-ZQKDLIV-BL6RNAR";}; # Acer Aspire A515-52G
        "nanpi" = {id = "3T56X4H-5RBU6HH-PKI4YAW-OZA27AA-M7AWUYP-HMNKCJJ-32WWOIB-TUGQ3AA";}; # Lenovo IdeaPad 3
      };
    };
  };
}
