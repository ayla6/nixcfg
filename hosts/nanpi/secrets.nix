{self, ...}: {
  age.secrets = {
    aylaPassword.file = "${self.inputs.secrets}/ayla/crazierPasswordHash.age";
    postgres-forgejo.file = "${self.inputs.secrets}/postgres/forgejo.age";
    pds.file = "${self.inputs.secrets}/pds.age";
    resticPassword.file = "${self.inputs.secrets}/restic-passwd.age";
    rclone.file = "${self.inputs.secrets}/rclone.age";
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/auth.age";
    syncthingCert.file = "${self.inputs.secrets}/ayla/syncthing/nanpi/cert.age";
    syncthingKey.file = "${self.inputs.secrets}/ayla/syncthing/nanpi/key.age";
    ntfyAuto.file = "${self.inputs.secrets}/ntfyAuto.age";
  };
}
