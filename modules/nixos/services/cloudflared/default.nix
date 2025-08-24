{
  config,
  lib,
  self,
  ...
}: {
  options.myNixOS.services.cloudflared.enable = lib.mkEnableOption "Cloudflared for all your cloudflare tunnels needs";

  config = lib.mkIf config.myNixOS.services.cloudflared.enable {
    age.secrets = {
      cloudflareCertificate.file = "${self.inputs.secrets}/cloudflare/certificate.age";
      cloudflareCredentials.file = "${self.inputs.secrets}/cloudflare/credentials.age";
    };

    services.cloudflared = {
      enable = true;
      certificateFile = config.age.secrets.cloudflareCertificate.path;
      tunnels = {
        ${config.mySnippets.aylac-top.cloudflareTunnel} = {
          certificateFile = config.age.secrets.cloudflareCertificate.path;
          credentialsFile = config.age.secrets.cloudflareCredentials.path;
          default = "http_status:404";
        };
      };
    };
  };
}
