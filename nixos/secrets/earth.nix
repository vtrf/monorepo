{ config, ... }:

{
  age.secrets."earth-wg-private".file = ../../secrets/earth-wg-private.age;
  age.identityPaths = [ "/home/${config.meta.username}/.ssh/id_rsa" ];
}
