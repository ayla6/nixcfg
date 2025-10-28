{lib, ...}: {
  options.mySnippets.git = {
    user = lib.mkOption {
      type = lib.types.attrs;
      default = {
        name = "ayla";
        email = "ayla-git.barcode041@silomails.com";
      };
    };
  };
}
