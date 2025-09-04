{
  self,
  inputs,
  ...
}: {
  flake = {
    diskoConfigurations = {
      btrfs-subvolumes = ../disko/btrfs-subvolumes;
      luks-btrfs-subvolumes = ../disko/luks-btrfs-subvolumes;
      lvm-ext4 = ../disko/lvm-ext4;
      btrfs-vps = ../disko/btrfs-vps;
    };

    nixosModules = {
      hardware = ../hardware;
      locale-en-gb = ../locale/en-gb;
      nixos = ../nixos;
      snippets = ../snippets;
      users = ../users;
    };

    nixosConfigurations = let
      modules = self.nixosModules;
    in
      inputs.nixpkgs.lib.genAttrs [
        "morgana"
        "nanpi"
        "jezebel"
      ] (
        host:
          inputs.nixpkgs.lib.nixosSystem {
            modules = [
              ../../hosts/${host}
              inputs.agenix.nixosModules.default
              inputs.copyparty.nixosModules.default
              inputs.disko.nixosModules.disko
              inputs.home-manager.nixosModules.home-manager
              inputs.lanzaboote.nixosModules.lanzaboote
              inputs.tangled-core.nixosModules.knot
              inputs.tgirlpkgs.nixosModules.default
              modules.hardware
              modules.nixos
              modules.snippets
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
                    self.inputs.copyparty.overlays.default
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
