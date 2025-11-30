_: {
  flake = {
    homeConfigurations = {
      ayla = {imports = [../../homes/ayla ../home];};
    };

    homeModules = {
      default = ../home;
      snippets = ../snippets;
    };
  };
}
