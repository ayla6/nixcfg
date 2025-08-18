{self, ...}: {
  age.secrets = {
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/auth.age";
    resticPassword.file = "${self.inputs.secrets}/restic-passwd.age";
    rclone.file = "${self.inputs.secrets}/rclone.age";
  };
}
