_: {
  flake = {
    homeConfigurations = {
      ayla = ../../homes/ayla;
    };

    homeModules = {
      default = ../home;
      snippets = ../snippets;
    };
  };
}
