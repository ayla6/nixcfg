{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  name = "forgejo";
  cfg = config.myNixOS.services.${name};

  network = config.mySnippets.aylac-top;
  service = network.networkMap.${name};
in {
  options.myNixOS.services.${name} = {
    enable = lib.mkEnableOption "forgejo git forge";

    autoProxy = lib.mkOption {
      default = true;
      example = false;
      description = "${name} auto proxy";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    age.secrets.cloudflareFail2ban.file = "${self.inputs.secrets}/cloudflare/fail2ban.age";

    services = {
      cloudflared.tunnels."${network.cloudflareTunnel}".ingress = lib.mkIf cfg.autoProxy {
        "${service.vHost}" = "http://${service.hostName}:${toString service.port}";
      };

      forgejo = {
        enable = true;

        lfs.enable = true;
        package = pkgs.forgejo;

        settings = {
          actions = {
            ARTIFACT_RETENTION_DAYS = 15;
            DEFAULT_ACTIONS_URL = "https://github.com";
            ENABLED = false;
          };

          cron = {
            ENABLED = true;
            RUN_AT_START = false;
          };

          DEFAULT.APP_NAME = "git.aylac.top";
          federation.ENABLED = true;
          indexer.REPO_INDEXER_ENABLED = true;

          log = {
            ENABLE_SSH_LOG = true;
            LEVEL = "Debug";
          };

          mailer = {
            ENABLED = false;
          };

          migrations = {
            ALLOW_LOCALNETWORKS = true;
          };

          picture = {
            AVATAR_MAX_FILE_SIZE = 5242880;
            ENABLE_FEDERATED_AVATAR = true;
          };

          repository = {
            DEFAULT_BRANCH = "main";
            ENABLE_PUSH_CREATE_ORG = true;
            ENABLE_PUSH_CREATE_USER = true;
            PREFERRED_LICENSES = "GPL-3.0";
          };

          security.PASSWORD_CHECK_PWN = true;

          server = {
            DOMAIN = service.vHost;
            HTTP_PORT = service.port;
            LANDING_PAGE = "explore";
            LFS_START_SERVER = true;
            ROOT_URL = "https://${service.vHost}/";
            DISABLE_SSH = true;
          };

          service = {
            ALLOW_ONLY_INTERNAL_REGISTRATION = true;
            DISABLE_REGISTRATION = true;
            ENABLE_NOTIFY_MAIL = true;
          };

          session.COOKIE_SECURE = true;

          storage = {
            STORAGE_TYPE = "local";
            PATH = "/var/lib/forgejo/data";
          };

          ui.DEFAULT_THEME = "forgejo-auto";

          "ui.meta" = {
            AUTHOR = "Ayla";
            DESCRIPTION = "i can't set up ssh via cloudflare tunnels!";
            KEYWORDS = "git,source code,forge,forgejo,aylac";
          };
        };
      };
    };
  };
}
