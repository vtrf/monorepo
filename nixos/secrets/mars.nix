{ config, ... }:

{
  age.secrets."mars-wg-private".file = ../../secrets/mars-wg-private.age;
}
