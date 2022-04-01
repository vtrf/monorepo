{ config, ... }:

let
  inherit (config.meta) username;
in
{
  users.mutableUsers = true;

  users.users."${username}" = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [
      "docker"
      "kvm"
      "libvirtd"
      "networkmanager"
      "wheel"
    ];
    initialPassword = "changeme";

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZDX7aUmSk23xC6asykCpXUztBxp4r5EVJx+61JjO72Mx/FxoVmLtMXLJXwhsWF38Qa8/JUINaBtCaf8TglIVsqovVmrxzvx4xk8WgjskRrPPdq+RXdyzFFz8Tbr2DqytorRiP9qP+V3aCI+ea/lwMqusi2l0f2/PB+mXU1/fUcq/mEz5bFSUUntv268K3Re8t98rJgwsVSqVBIbZeuUWOUUtn2y4SZN6hPwyYuUajcq2rtQeGGmGuTU0FEUsPA+s9rGOB63wU6sAhJD3WN1nim7hy0F/N4Hb77NGkuORkPuZya+Dekq/+Z3+FbqjXdu+1VCgKxRtvdn2g9fkGn6yJvg3WIYae6FOKs08c5Orc2lYwkK8LS7NxX4SI5k3imebrNUwQAelhS63BUFhxp1K5g5YtptxxA/R0BAoJZAoy1QIXPjqCAUYzHJ+niJSPe7G2YusQC0S/Gf90KEcOT/xRlF5u1CU7ZJRXFAlmIMdWlaQTKrXHGvrP0WKSSOju8bk="
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIEpBZXIOn5Eeq2peV4gH3jSf2fqinRnTPHd1NHlscLZ"
    ];
  };
}


