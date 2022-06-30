{ config, pkgs, ... }:

{
  systemd.services.dendrite.after = [
    "network.target"
    "postgresql.service"
  ];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_13;
    enableTCPIP = true;
    initialScript = pkgs.writeText "backend-initScript" ''
      CREATE ROLE dendrite WITH LOGIN PASSWORD 'dendrite' CREATEDB;
      CREATE DATABASE dendrite;
      GRANT ALL PRIVILEGES ON DATABASE dendrite TO dendrite;
    '';
  };
}
