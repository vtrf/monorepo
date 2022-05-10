{ config, ... }:

let
  inherit (config.services) dendrite;
  dendriteServerName = dendrite.settings.global.server_name;
  connectionString = "postgres://dendrite:dendrite@127.0.0.1/dendrite?sslmode=disable";
  federationPort = 8448;
in
{
  services.dendrite = {
    enable = true;

    settings = {
      app_service_api.database.connection_string = connectionString;
      federation_api.database.connection_string = connectionString;
      key_server.database.connection_string = connectionString;
      media_api.database.connection_string = connectionString;
      mscs.database.connection_string = connectionString;
      room_server.database.connection_string = connectionString;
      sync_api.database.connection_string = connectionString;
      user_api.account_database.connection_string = connectionString;
      user_api.device_database.connection_string = connectionString;

      client_api.registration_disabled = true;

      mscs.mscs = [
        # threading
        "msc2946"
        # spaces
        "msc2836"
      ];

      federation_api = {
        external_api = {
          listen = "http://localhost:${toString federationPort}";
        };
      };

      global = {
        metrics.enabled = true;
        server_name = "mdzk.app";
        private_key = config.age.secrets.dendrite.path;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 federationPort ];
  services.nginx.virtualHosts."matrix.${dendriteServerName}" = {
    enableACME = true;
    forceSSL = true;

    locations = {
      "/_matrix" = {
        proxyPass = "http://localhost:${toString config.services.dendrite.httpPort}";
      };
    };
  };

  security.acme.certs."matrix.${dendriteServerName}" = {
    email = "victor@freire.dev.br";
  };

  services.prometheus.scrapeConfigs = [
    {
      job_name = "dendrite";
      static_configs = [{
        targets = [
          "127.0.0.1:${toString config.services.dendrite.httpPort}"
        ];
      }];
    }
  ];
}
