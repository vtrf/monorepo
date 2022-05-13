# mata

[mata](https://git.sr.ht/~glorifiedgluer/mata) is CLI tool for [mataroa.blog](https://mataroa.blog).

# Table of Contents

- [mata](#mata)
- [Table of Contents](#table-of-contents)
  - [Usage](#usage)
  - [Documentation](#documentation)
  - [Building](#building)
    - [From Source](#from-source)
    - [From Nix](#from-nix)
  - [Contributing](#contributing)
- [License](#license)

## Usage

Run `mata init` to get started. Read the man page to learn about all commands.

## Documentation

Also available as a man page:

- [mata(1)](https://git.sr.ht/~glorifiedgluer/monorepo/tree/main/item/mata/doc/mata.1.scd)

## Building

Dependencies (not needed for Nix users):

- Go
- Pandoc (optional, for man pages)

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

You can find me on IRC: [#mdzk on Libera Chat](ircs://irc.libera.chat/#mdzk).

# License

MIT, see [LICENSE](https://git.sr.ht/~glorifiedgluer/mata/tree/master/LICENSE).

Copyright (C) 2022 Victor Freire
