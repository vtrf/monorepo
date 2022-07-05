+++
title = "Statically Compiling Go"
author = ["Victor Freire"]
draft = false
+++

Notes on how to statically compile a [Go]({{< relref "20220704154106-go.md" >}}) program.


## Statically Compiling {#statically-compiling}

-   Some packages use [cgo in Go Standard Library]({{< relref "20220704153515-cgo_in_go_standard_library.md" >}}). To skip cgo parts, do the following:

<!--listend-->

```shell
go build -tags osusergo
go build -tags netgo
go build -tags osusergo,netgo
```

-   To skip all cgo whatsoever: `CGO_ENABLED=0 go build`
-   We can statically compile the cgo part too: `go build -ldflags="-extldflags=-static"`


## Statically Cross Compiling {#statically-cross-compiling}


### `aarch64` with `musl` {#aarch64-with-musl}

```shell
GOOS=linux GOARCH=arm64 CGO_ENABLED=1 CC=aarch64-linux-musl-gcc \
    go build -ldflags='-extldflags=-static'
```
