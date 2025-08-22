{inputs, ...}: {
  imports = [
    ./desktop
    ./programs
    ./services
    ./profiles
    ./packages.nix
    inputs.agenix.homeManagerModules.default
    inputs.zen-browser.homeModules.beta
  ];

  home = {
    stateVersion = "25.05";
    shell.enableFishIntegration = true;
  };

  programs.home-manager.enable = true;
}
