{inputs, ...}: {
  imports = [
    ./desktop
    ./programs
    ./profiles
    ./snippets
    inputs.agenix.homeManagerModules.default
    inputs.aylapkgs.homeModules.default
    inputs.nix-flatpak.homeManagerModules.nix-flatpak
  ];

  home = {
    stateVersion = "25.05";
    shell.enableFishIntegration = true;
  };

  programs.home-manager.enable = true;
}
