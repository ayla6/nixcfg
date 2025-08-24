# Borrowed graciously from https://github.com/WiredMic/nix-config/commit/d9268ce5190a2041ef66b492900eed278d1508e2#diff-9db90aeeaf81739c27dcdab8065abc8709d0bd5428bc658cff2db46acc91536a
{
  config,
  lib,
  pkgs,
  utils,
  ...
}: let
  name = "qbittorrent";
  cfg = config.myNixOS.services.${name};

  network = config.mySnippets.tailnet;
  service = network.networkMap.${name};
in {
  options.myNixOS.services.qbittorrent = {
    enable = lib.mkEnableOption "qBittorrent headless";

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/qbittorrent";
      description = "The directory where qBittorrent stores its data files.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "qbittorrent";
      description = "User account under which qBittorrent runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "qbittorrent";
      description = "Group under which qBittorrent runs.";
    };

    webuiPort = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "qBittorrent web UI port.";
    };

    torrentingPort = lib.mkOption {
      type = lib.types.port;
      default = 16620;
      description = "qBittorrent torrenting port.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open services.qBittorrent.port to the outside network.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.qbittorrent-nox;
      defaultText = lib.literalExpression "pkgs.qbittorrent-nox";
      description = "The qbittorrent package to use.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = ''
        Extra arguments passed to qbittorrent. See `qbittorrent -h`, or the [source code](https://github.com/qbittorrent/qBittorrent/blob/master/src/app/cmdoptions.cpp), for the available arguments.
      '';
      example = [
        "--confirm-legal-notice"
      ];
    };

    autoProxy = lib.mkOption {
      default = true;
      example = false;
      description = "${name} auto proxy";
      type = lib.types.bool;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall (
      lib.optionals (cfg.webuiPort != null) [cfg.webuiPort]
      ++ lib.optionals (cfg.torrentingPort != null) [cfg.torrentingPort]
    );

    services.caddy.virtualHosts."${service.vHost}".extraConfig = lib.mkIf cfg.autoProxy ''
      bind tailscale/${name}
      encode zstd gzip
      reverse_proxy ${service.hostName}:${toString service.port}
    '';

    systemd.services.qbittorrent = {
      after = ["local-fs.target" "network-online.target"];
      description = "qBittorrent-nox service";
      documentation = ["man:qbittorrent-nox(1)"];
      requires = ["local-fs.target" "network-online.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;

        # Run the pre-start script with full permissions (the "!" prefix) so it
        # can create the data directory if necessary.
        ExecStartPre = let
          preStartScript = pkgs.writeScript "qbittorrent-run-prestart" ''
            #!${pkgs.bash}/bin/bash

            # Create data directory if it doesn't exist
            if ! test -d "$QBT_PROFILE"; then
              echo "Creating initial qBittorrent data directory in: $QBT_PROFILE"
              install -d -m 0755 -o "${cfg.user}" -g "${cfg.group}" "$QBT_PROFILE"
            fi
          '';
        in "!${preStartScript}";

        ExecStart = utils.escapeSystemdExecArgs (
          [
            (lib.getExe cfg.package)
          ]
          ++ lib.optionals (cfg.torrentingPort != null) ["--torrenting-port=${toString cfg.torrentingPort}"]
          ++ cfg.extraArgs
        );
        # To prevent "Quit & shutdown daemon" from working; we want systemd to
        # manage it!
        #Restart = "on-success";
        #UMask = "0002";
        #LimitNOFILE = cfg.openFilesLimit;
      };

      environment = {
        QBT_PROFILE = cfg.dataDir;
        QBT_WEBUI_PORT = toString cfg.webuiPort;
      };
    };

    users = {
      users = lib.mkIf (cfg.user == "qbittorrent") {
        qbittorrent = {
          inherit (cfg) group;
          isSystemUser = true;
        };
      };
      groups = lib.mkIf (cfg.group == "qbittorrent") {qbittorrent = {};};
    };
  };
}
