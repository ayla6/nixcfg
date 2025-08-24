{
  config,
  lib,
  self,
  ...
}: let
  name = "karakeep";
  cfg = config.myNixOS.services.${name};

  network = config.mySnippets.tailnet;
  service = network.networkMap.${name};
in {
  options.myNixOS.services.${name} = {
    enable = lib.mkEnableOption "${name} server";
    autoProxy = lib.mkOption {
      default = true;
      example = false;
      description = "${name} auto proxy";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.gemini.file = "${self.inputs.secrets}/gemini.age";

    services = {
      caddy.virtualHosts."${service.vHost}".extraConfig = lib.mkIf cfg.autoProxy ''
        bind tailscale/${name}
        encode zstd gzip
        reverse_proxy ${service.hostName}:${toString service.port}
      '';

      karakeep = {
        enable = true;

        extraEnvironment = rec {
          DISABLE_NEW_RELEASE_CHECK = "true";
          DISABLE_SIGNUPS = "true";
          OPENAI_BASE_URL = "https://generativelanguage.googleapis.com/v1beta/openai/";
          INFERENCE_TEXT_MODEL = "gemini-2.5-flash";
          INFERENCE_IMAGE_MODEL = INFERENCE_TEXT_MODEL;
          EMBEDDING_TEXT_MODEL = INFERENCE_TEXT_MODEL;
          INFERENCE_CONTEXT_LENGTH = "600000";
          INFERENCE_LANG = "english";
          INFERENCE_NUM_WORKERS = "2";
          NEXTAUTH_URL = "https://${service.vHost}";
          PORT = "7020";
        };
        environmentFile = config.age.secrets.gemini.path;
      };
    };
  };
}
