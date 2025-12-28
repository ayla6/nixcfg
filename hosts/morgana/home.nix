{self, ...}: {
  home-manager.users = {
    inherit (self.homeConfigurations) ayla;
  };
}
