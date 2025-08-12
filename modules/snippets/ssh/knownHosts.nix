{
  config,
  lib,
  self,
  ...
}: {
  options.mySnippets.ssh.knownHosts = lib.mkOption {
    type = lib.types.attrs;
    description = "Default ssh known hosts.";

    default = {
      morgana = {
        hostNames = ["morgana" "morgana.local" "morgana.${config.mySnippets.tailnet.name}"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_morgana.pub";
      };

      ayla_morgana = {
        hostNames = ["morgana" "morgana.local" "morgana.${config.mySnippets.tailnet.name}"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/ayla_morgana.pub";
      };

      nanpi = {
        hostNames = ["nanpi" "nanpi.local" "nanpi.${config.mySnippets.tailnet.name}"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/root_nanpi.pub";
      };

      m23 = {
        hostNames = ["m23" "m23.local" "m23.${config.mySnippets.tailnet.name}"];
        publicKeyFile = "${self.inputs.secrets}/publicKeys/ayla_m23.pub";
      };
    };
  };
}
