+++
title = "cgo in Go Standard Library"
author = ["Victor Freire"]
draft = false
+++

-   `os/user`: There's a C library used to transform user and group ids to user
    and group names. It can also get names from LDAP.

-   `net`: Uses a C library to resolve DNS and help on platforms that don't have a
    resolv.conf.

Both have a pure [Go]({{< relref "20220704154106-go.md" >}}) implementation to some degree.
