---
title: "Notes on builds.sr.ht"
slug: "notes-on-buildssrht"
date: "2022-04-29"
author: "freire"
summary: |
  I quite like builds.sr.ht and want to share some of the reasons.
---

For the past few months I've been using [sourcehut][]'s platform to work on
software an it has been quite an interesting experience. Nonetheless, one of
the services I really enjoy using is the their build service called
[builds.sr.ht][].

> builds.sr.ht is a service on sr.ht that allows you to submit "build
> manifests" for us to work on.
> > [man.sr.ht](https://man.sr.ht/builds.sr.ht/)

The thing I don't like on [GitHub Actions] is that it is kind of _magical_. For
example, you don't actually know what it is doing when you define that an
`action` should only run when a specific path is modified. Not to even mention
their [custom actions](https://docs.github.com/pt/actions/creating-actions)
which usually takes a non-trivial amount of TypeScript/JavaScript.

Contrary to this, [builds.sr.ht][] is _really_ explicit on its [build
manifest][]. You're basically expected to write plain shell scripts for your
builds.

## Reducing resource usage

As I said previously, there's no special syntax to work on specific paths,
branches, pull requests and such. By default your task will run on every commit
you push. In order to reduce our CI usage we can restrain our tasks to run on
specific scenarios:

### On path change

```bash
if ! $(git diff --quiet HEAD HEAD^ -- "<your-path>")
then
  # do something
fi
```

### On branch change

This tip was taken from [issue #170](https://todo.sr.ht/~sircmpwn/builds.sr.ht/170).

```yaml
tasks:
- check-branch: |
   cd repo_name
   if [ "$(git rev-parse your-branch)" != "$(git rev-parse HEAD)" ]; then \
      complete-build; \
   fi
```

## NixOS on builds.sr.ht

As I don't like to write shell scripts I use Nix and this is my
favorite feature of this service. builds.sr.ht supports [NixOS][] by
default[^1]. This means that we can leverage Nix Flakes for truly declarative
and reproducible builds there! Let's consider a small example using
[Go](https://go.dev) to show you how easy it really is. A small `flake.nix`
containing the following content should suffice our needs:

```nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
    let pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      devShells."x86_64-linux".ci = with pkgs; mkShell {
        buildInputs = [ go golangci-lint ];
      };
    };
}
```

This definition is capable of giving us a shell containing Go and
[golangci-lint](https://github.com/golangci/golangci-lint) on `$PATH`. Now
let's write the build manifest for our CI:

```yaml
image: nixos/unstable
packages:
- nixos.nixUnstable
environment:
  NIX_CONFIG: "experimental-features = nix-command flakes"
tasks:
  - lint: |
      cd source
      nix develop .#ci -c golangci-lint run
  - test: |
      cd source
      nix develop .#ci -c go test ./...
  - build: |
      cd source
      nix develop .#ci -c go build
```

And that's it! We have our CI up and running with the guarantee of having our
tools being the same on every run. No sudden updates or unexpected behavior.

[^1]: <https://man.sr.ht/builds.sr.ht/compatibility.md#nixos>

[build manifest]: https://man.sr.ht/builds.sr.ht/manifest.md
[builds.sr.ht]: https://builds.sr.ht
[github actions]: https://github.com/features/actions
[nixos]: https://nixos.org
[sourcehut]: https://sr.ht
