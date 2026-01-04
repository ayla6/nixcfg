{inputs, self, ...}: {
  flake = {
    homeConfigurations = {
      ayla = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs self;};
        modules = [
          ../../homes/ayla
          ../home
        ];
      };
    };

    homeModules = {
      default = ../home;
      snippets = ../snippets;
    };
  };
}
