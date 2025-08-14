{inputs, ...}: {
  imports = [
    ./desktop
    ./programs
    ./services
    ./profiles
    ./themes
    ./packages.nix
    ./hidden.nix
    inputs.agenix.homeManagerModules.default
  ];

  home = {
    stateVersion = "25.05";
    shell.enableFishIntegration = true;
  };

  programs.home-manager.enable = true;
}
