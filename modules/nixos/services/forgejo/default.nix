{
  config,
  lib,
  pkgs,
  self,
  ...
}: {
  options.myNixOS.services.forgejo = {
    enable = lib.mkEnableOption "forĝejo git forge";

    db = lib.mkOption {
      description = "Database to use (sqlite or postgresql).";
      default = "sqlite";
      type = lib.types.str;
    };
  };

  config = lib.mkIf config.myNixOS.services.forgejo.enable {
    age.secrets = {
      postgres-forgejo.file = "${self.inputs.secrets}/postgres/forgejo.age";
    };

    services = {
      postgresql = lib.mkIf (config.myNixOS.services.forgejo.db
        == "postgresql") {
        enable = true;
        package = pkgs.postgresql_16;
        ensureDatabases = ["forgejo"];

        ensureUsers = [
          {
            name = "forgejo";
            ensureDBOwnership = true;
          }
        ];
      };

      forgejo = {
        enable = true;

        database = lib.mkIf (config.myNixOS.services.forgejo.db
          == "postgresql") {
          createDatabase = true;
          host = "127.0.0.1";
          name = "forgejo";
          passwordFile = config.age.secrets.postgres-forgejo.path;
          type = "postgres";
          user = "forgejo";
        };

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
            DOMAIN = config.mySnippets.aylac-top.networkMap.forgejo.vHost;
            HTTP_PORT = config.mySnippets.aylac-top.networkMap.forgejo.port;
            LANDING_PAGE = "explore";
            LFS_START_SERVER = true;
            ROOT_URL = "https://${config.mySnippets.aylac-top.networkMap.forgejo.vHost}/";
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
            KEYWORDS = "git,source code,forge,forĝejo,aylac";
          };
        };
      };
    };
  };
}
