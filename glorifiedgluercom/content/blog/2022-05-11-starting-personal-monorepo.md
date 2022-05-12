---
title: "Starting a personal monorepo"
slug: "starting-personal-monorepo"
date: "2022-05-11"
author: "freire"
tags:
  - nix
summary: |
  Starting my journey with a personal monorepo managed by Nix.
---
I've been using [Nix][] as my package manager for 4 years now and it has been
the best _computer-related_ decision I have ever made and fortunately, for the
past few years its ecosystem has been growing a lot[^1] [^2] [^3]. Some of this
movement is due to the advent o [Flakes][] that makes it _way_ easier to share
reproducible outputs than the previous Nix solution of channels.

Considering that I can use Nix:

- to share build artifacts (binaries, Nix modules and such);
- to manage my dependencies;
- as a build system.

I thought to myself: "Why not build a personal monorepo"? I mean, this might
sound like a weird conclusion to take from all of this but I can explain! I
swear!

# Rationale

Sometimes I just get bored setting up a new project. Create a new repository,
setup the dependencies, write a CI manifest... it's too tiresome! I won't even
mention the pain in the ass that is to write multiple projects on the multiple
machines. The clone, fetch, pull and push dance is just too much when I could be
coding already.

Most of my personal projects are written in [Go](https://go.dev), a really
boring language that takes its time to include new features and release new
versions. This means that an update won't break them and that I can take
advantage of a way to share the same compiler and tooling version through
my projects.

If you're a Nix user, a single command would show you all the outputs available
for use: `nix flake show sourcehut:~glorifiedgluer/monorepo`. This also means
that you can import this repo as an input on your `flake.nix` file and use any
of my projects as you please.

The CI can be simplified to a simple shell conditional:

```yaml
tasks:
  - someproject: |
      cd monorepo
      if ! $(git diff --quiet HEAD HEAD^ -- "someproject")
      then
        # do something if the project got an update
      fi
```

Nonetheless, the best reason to try this is out is to have some fun and explore
new challenges with version control and build systems! ;-)

# Expectation

I mean... none? lol. Being serious now, I don't expect my projects to become
something used by hundreds or thousands of users as most of them are done out
of passion/need. So the rationale above is composed of things that personally
took out part of the joy of bulding out
something and seeing it run.

Is this going to work? I have no idea as I don't have much experience with
monorepos. I'm not really sure if this is going to scale or bore me in other
ways. The only certainty I have is that I'm having fun doing it _right now_!

You can see the repository on the links below:

- [GitHub](https://github.com/ratsclub/monorepo)
- [sourcehut](https://git.sr.ht/~glorifiedgluer/monorepo/)

[^1]: https://blog.replit.com/nix
[^2]: https://shopify.engineering/what-is-nix
[^3]: https://hercules-ci.com/

[flakes]: https://nixos.wiki/wiki/Flakes
[nix]: https://nixos.org
