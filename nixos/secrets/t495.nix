{ config, ... }:

{
  age.identityPaths = [
    "/home/${config.meta.username}/.ssh/id_ed25519"
  ];
}
