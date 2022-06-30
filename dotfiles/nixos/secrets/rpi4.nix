{ config, ... }:

{
  age.secrets."dendrite" = {
    file = ../../secrets/dendrite.age;
    mode = "755";
  };

  age.identityPaths = [
    "/home/${config.meta.username}/.ssh/id_ed25519"
  ];
}
