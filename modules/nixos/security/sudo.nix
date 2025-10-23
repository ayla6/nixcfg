{
  security.sudo-rs = {
    enable = true;
    wheelNeedsPassword = false;
    execWheelOnly = true;

    extraConfig = ''
      Defaults !lecture
      Defaults env_keep += "EDITOR PATH DISPLAY"
      Defaults timestamp_timeout = 30
    '';
  };
}
