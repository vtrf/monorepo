---
title: mata
source: https://git.sr.ht/~glorifiedgluer/mata
summary: CLI tool for mataroa.blog
---
## Usage

Run `mata init` to get started. Read the man page to learn about all commands.

## Table of Contents

- [Usage](#usage)
- [Table of Contents](#table-of-contents)
- [Documentation](#documentation)
- [Building](#building)
  - [From Source](#from-source)
  - [From Nix](#from-nix)
- [Contributing](#contributing)
- [License](#license)

## Documentation

Also available as man pages:

<!-- TODO: write man pages with scdoc -->

## Building

Dependencies (not needed for Nix users):

- [Go][]
- [scdoc][] (optional, for man pages)

### From Source

For end users, a Makefile is provided:

```
make
make install
```

### From Nix

Dependencies:

- Nix 2.4 or later

You can build and run from your machine with the following:

```
nix run sourcehut:~glorifiedgluer/mata
```

## Contributing

<!-- TODO: add contributing section -->

## License

MIT, see [LICENSE](https://git.sr.ht/~glorifiedgluer/mata/tree/master/LICENSE).

Copyright (C) 2022 Victor Freire

[scdoc]: https://git.sr.ht/~sircmpwn/scdoc
[go]: https://go.dev
