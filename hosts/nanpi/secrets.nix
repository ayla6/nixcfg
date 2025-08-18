{self, ...}: {
  age.secrets = {
    cloudflareCertificate.file = "${self.inputs.secrets}/cloudflare/certificate.age";
    cloudflareCredentials.file = "${self.inputs.secrets}/cloudflare/credentials.age";
    pds.file = "${self.inputs.secrets}/pds.age";
    resticPassword.file = "${self.inputs.secrets}/restic-passwd.age";
    rclone.file = "${self.inputs.secrets}/rclone.age";
    tailscaleAuthKey.file = "${self.inputs.secrets}/tailscale/auth.age";
    syncthingCert.file = "${self.inputs.secrets}/ayla/syncthing/nanpi/cert.age";
    syncthingKey.file = "${self.inputs.secrets}/ayla/syncthing/nanpi/key.age";
    vaultwarden.file = "${self.inputs.secrets}/vaultwarden.age";
  };
}
