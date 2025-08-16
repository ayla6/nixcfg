{
  description = "Aly's NixOS flake with flake-parts";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    actions-nix = {
      url = "github:alyraffauf/actions.nix";

      inputs = {
        git-hooks.follows = "git-hooks-nix";
        nixpkgs.follows = "nixpkgs";
      };
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    files.url = "github:alyraffauf/files";

    firefox-onebar = {
      url = "https://git.gay/freeplay/Firefox-Onebar/raw/branch/waf/onebar.css";
      flake = false;
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    fontix = {
      url = "github:alyraffauf/fontix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    secrets = {
      url = "github:ayla6/secrets";
      flake = false;
    };

    tangled-core = {
      url = "git+https://tangled.sh/@tangled.sh/core";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    accept-flake-config = true;

    extra-substituters = [
      "https://ayla6.cachix.org"
      "https://chaotic-nyx.cachix.org/"
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "ayla6.cachix.org-1:40BzoflmIK8MovQ5zewLsWlDNWQh7Gdtu2i220h1YmE="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8"
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
      ];

      imports = [
        ./modules/flake
        inputs.actions-nix.flakeModules.default
        inputs.files.flakeModules.default
        inputs.git-hooks-nix.flakeModule
        inputs.home-manager.flakeModules.home-manager
      ];
    };
}
