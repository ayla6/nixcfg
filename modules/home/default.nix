{inputs, ...}: {
  imports = [
    ./desktop
    ./programs
    ./services
    ./profiles
    ./style
    ./packages.nix
    ./hidden.nix
    inputs.agenix.homeManagerModules.default
  ];

  home.username = "ayla";
  home.homeDirectory = "/home/ayla";

  home.stateVersion = "25.05";
  home.shell.enableFishIntegration = true;

  programs.home-manager.enable = true;
}
