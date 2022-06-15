---
title: "Git mirroring, systemd and NixOS"
slug: "git-mirroring-systemd-nixos"
date: "2022-06-14"
summary: |
  Configuring a Git mirror with systemd services and timers on NixOS.
tags:
  - nix
  - git
toc: true
---
For the past few years I have been collecting contributions to multiple projects
on multiple platforms such as GitHub, GitLab, self-hosted Gitea instances and so
on. It's rather boring to go to a website and see the source code there... Then
I thought to myself: "Why not write about a made up need I don't have just to
learn something new?"

So, the idea here was to mirror those repositories into my [sourcehut][]
account (although this should work for any remote repository). For this we will
use a [NixOS][] system and [systemd timers][systemd timer]. The idea is dead
simple, we clone the repositories and push them to our desired remote.

## Configuring the repository

This step is pretty easy and can be done in two steps:

1. Clone the repository

```bash
$ git clone --mirror https://git.com/repo
```

2. Configure the remote as to ensure that we will only push to the desired
remote.

```sh
$ cd repo
$ git remote set-url --push origin https://remote.com/repo-mirror
```

## systemd to the rescue

We have our repository but we are still missing an important step that is to
keep pushing new changes to our mirror. 

[NixOS][] has a pretty good declarative way of declaring systemd services and
timers that we can take advantage of here. The idea is to have a script being
ran in our diretory through a systemd *service* that will be invoked by a
systemd *timer* hourly.

### The script

There's nothing novel here. It's just a script that will fetch the latest
references and then push them to our mirror.

```nix
let
  gitmirrorScript = pkgs.writeShellScriptBin "gitmirror" ''
    git fetch -p origin
    git push --mirror
  '';
in
```

### The service and timer

The service is rather simple too, we pass our repository's directory through the
`WorkingDirectory` value and set the `gitmirror` service as the unit to be
invoked by our timer.

```nix
{
  systemd.services.gitmirror = {
    enable = true;
    description = "Git mirror service";
    after = [ "network.target" ];
    path = [ pkgs.git ];
    serviceConfig = {
      Type="oneshot";
      WorkingDirectory = "/home/glorifiedgluer/repo";
      ExecStart = "${gitmirrorScript}/bin/gitmirror";
    };
    wantedBy = [ "multi-user.target" ];
  };

  systemd.timers.gitmirror = {
    description = "Git mirror timer";
    timeConfig = {
      OnCalendar = "hourly";
      Unit = "gitmirror.service";
    };
    wantedBy = [ "timers.target" ];
  };
}
```

[sourcehut]: https://sourcehut.org
[nixos]: https://nixos.org
[systemd timer]: https://www.freedesktop.org/software/systemd/man/systemd.timer.html