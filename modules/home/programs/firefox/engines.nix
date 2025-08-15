{
  "Unduck" = {
    icon = "https://unducking.pages.dev/search.svg";

    urls = [
      {
        template = "https://unducking.pages.dev/?q={searchTerms}&d=ddg";
      }
    ];
  };

  "Home Manager Options" = {
    icon = "https://home-manager-options.extranix.com/images/favicon.png";
    definedAliases = ["!hm"];

    urls = [
      {
        template = "https://home-manager-options.extranix.com/?release=master&query={searchTerms}";
      }
    ];
  };

  "NixOS Wiki" = {
    definedAliases = [
      "!nw"
      "!nixwiki"
    ];
    icon = "https://wiki.nixos.org/favicon.ico";
    updateInterval = 24 * 60 * 60 * 1000; # every day
    #metaData.hidden = true;

    urls = [
      {
        template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
      }
    ];
  };

  "nixpkgs" = {
    definedAliases = ["!nix" "!nixpkgs"];
    icon = "https://search.nixos.org/favicon.png";

    urls = [
      {
        template = "https://search.nixos.org/packages";
        params = [
          {
            name = "type";
            value = "packages";
          }
          {
            name = "query";
            value = "{searchTerms}";
          }
        ];
      }
    ];
  };

  "Wiktionary" = {
    definedAliases = ["!wikt" "!wt"];
    icon = "https://en.wiktionary.org/favicon.ico";
    updateInterval = 24 * 60 * 60 * 1000; # every day

    urls = [
      {
        template = "https://en.wiktionary.org/wiki/{searchTerms}";
      }
    ];
  };

  "wikipedia" = {
    definedAliases = ["!wikp" "!w"];
  };

  "bing" = {
    metaData = {
      hidden = true;
    };
  };

  "ddg" = {
    metaData = {
      hidden = true;
      alias = "!ddg";
    };
  };

  "google" = {
    metaData = {
      hidden = true;
      alias = "!google";
    };
  };
}
