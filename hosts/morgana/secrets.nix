{self, ...}: {
  age.secrets = {
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/auth.age";
    syncthingCert.file = "${self.inputs.secrets}/ayla/syncthing/morgana/cert.age";
    syncthingKey.file = "${self.inputs.secrets}/ayla/syncthing/morgana/key.age";
  };
}
