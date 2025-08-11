{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules = {
      hardware = ../hardware;
      locale-en-gb = ../locale/en-gb;
      nixos = ../nixos;
      users = ../users;
    };

    nixosConfigurations = let
      modules = self.nixosModules;
    in
      inputs.nixpkgs.lib.genAttrs ["morgana"] (
        host:
          inputs.nixpkgs.lib.nixosSystem {
            modules = [
              ../../hosts/${host}
              inputs.home-manager.nixosModules.home-manager
              inputs.lanzaboote.nixosModules.lanzaboote
              modules.hardware
              modules.nixos
              modules.users

              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {inherit inputs self;};
                  backupFileExtension = "backup";
                };

                nixpkgs = {
                  overlays = [
                    self.inputs.nur.overlays.default
                  ];
                  config.allowUnfree = true;
                };
              }
            ];
            specialArgs = {inherit self;};
          }
      );
  };
}
