{inputs, ...}: {
  imports = [
    ./desktop
    ./programs
    ./profiles
    ./snippets
    inputs.agenix.homeManagerModules.default
  ];

  home = {
    stateVersion = "25.05";
    shell.enableFishIntegration = true;
  };

  programs.home-manager.enable = true;
}
