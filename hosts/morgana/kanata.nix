{...}: {
  # Enable uinput so Kanata can inject keys
  hardware.uinput.enable = true;
  users.groups.uinput.members = ["ayla" "root"];

  services.kanata = {
    enable = true;
    keyboards.internalKeyboard = {
      config = builtins.readFile ./kanata.lisp;
    };
  };
}
