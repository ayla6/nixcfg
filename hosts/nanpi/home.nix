{self, ...}: {
  home-manager.users.ayla = {pkgs, ...}: {
    imports = [
      self.homeModules.default
      self.inputs.agenix.homeManagerModules.default
    ];

    age.secrets.rclone.file = "${self.inputs.secrets}/rclone.age";

    home = {
      homeDirectory = "/home/ayla";

      packages = with pkgs; [
        curl
        rclone
        restic
      ];

      stateVersion = "25.05";
      username = "ayla";
    };
    programs = {
      helix = {
        enable = true;
        defaultEditor = true;
      };

      micro = {
        enable = true;
      };

      home-manager.enable = true;
    };

    myHome = {
      programs = {
        git.enable = true;
        ssh.enable = true;
        fastfetch.enable = true;
      };

      profiles.shell.enable = true;
    };
  };
}
