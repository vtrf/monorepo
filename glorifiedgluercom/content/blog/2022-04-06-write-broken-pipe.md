---
title: "write: broken pipe"
slug: "write-broken-pipe"
date: "2022-04-06"
author: "freire"
summary: |
  The adventure of figuring out the "tcp: write: broken pipe" error.
---

**tl;dr**: [Kong Ingress Controller][] was the culprit. Its timeout setting was closing the
connection before the file could be sent. _If you're facing this issue in a
long-lasting request, check your reverse proxy configuration, as it may have a
different configuration than your application._ ;-)

At Grupo SBF we have an HTTP server written in [Go](https://go.dev/) that
queries [BigQuery](https://cloud.google.com/bigquery) and returns the result
as a **big** csv file. However, after some time we sent a request and instead
of a file, we received this error message:

```
write tcp 10.0.0.1:8080->10.0.0.2:38302: write: broken pipe
```

Well, this is quite a surprise as we haven't seen this error message before...
After all, what does it even mean? A quick Google search returned this:

> A condition in programming (also known in POSIX as EPIPE error code and
> SIGPIPE signal), when a process requests an output to pipe or socket, which
> was closed by peer
>
> > [Wikipedia](https://en.wikipedia.org/wiki/Broken_pipe)

Hmm, this _definitely_ shed some light on the problem. Considering that the
HTTP server is provided by the powerful [net/http](https://pkg.go.dev/net/http)
package in Go's standard library, we might have some obvious places to check
out.

Cloudflare has a [great
article](https://blog.cloudflare.com/exposing-go-on-the-internet/) talking
about the default configuration on Go's HTTP server and how to avoid making
mistakes with them. We jumped straight to the article's timeout section and
checked if we didn't forget to configure them.

```go
srv := &http.Server{
	ReadTimeout:  10 * time.Minute, // 10 minutes
	WriteTimeout: 10 * time.Minute,
	Addr:         ":8080",
	Handler:      r,
}
```

For context, our application takes about 2 minutes to send a response so this
isn't a problem for us as we have 10 minutes until a [504 server
error](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/504) is
returned.

To our amazement, sending the request to a local server returned no error
whatsoever. Comparing our local environment with production we also noticed
that our request was _dropped_ at exactly 1 minute of execution in production.
Therefore it must be something between our client and server!

Knowing that we deploy to a Kubernetes cluster with a [Kong Ingress
Controller][] ~controlling~ taking care of our reverse proxy, we checked its
documentation and... Bingo! This is the root of our problem, as per the [Kong
Ingress Controller Documentation][] the default timeout is `60_000`
milliseconds -- in other words, 1 minute!

## Replicating the behavior

Before trying something on our servers, why don't we replicate this behavior
locally? For this purpose we can run a `nginx` container and a simple Go HTTP
server with a similar functionality of our service.

The idea behind the test is to setup an endpoint that takes a lot of time writing
on the buffer while our reverse proxy has a timeout of only 2 seconds.

### Go server and Dockerfile

```go
func main() {
    mux := http.NewServeMux()
    mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        time.Sleep(time.Second * 10)

        // creating a large data size
        // that will take a long time to be written
        size := 900 * 1000 * 1000
        tpl := make([]byte, size)
        t, err := template.New("page").Parse(string(tpl))
        if err != nil {
            log.Printf("error parsing template: %s", err)
            return
        }

        if err := t.Execute(w, nil); err != nil {
            log.Printf("error writing: %s", err)
            return
        }
    })

    srv := &http.Server{
        ReadTimeout: 10 * time.Minute,
        WriteTimeout: 10 * time.Minute,
        Addr: ":8080",
        Handler: mux,
    }

    log.Println("server is running!")
    log.Println(srv.ListenAndServe())
}
```
And then the Dockerfile:

```Dockerfile
# server.Dockerfile
FROM golang:alpine AS build
RUN apk --no-cache add gcc g++ make git
WORKDIR /go/src/app
COPY . .
RUN go mod init server
RUN go mod tidy
RUN GOOS=linux go build -ldflags="-s -w" -o ./bin/web-app ./server.go

FROM alpine:3.13
RUN apk --no-cache add ca-certificates
WORKDIR /usr/bin
COPY --from=build /go/src/app/bin /go/bin
EXPOSE 8080
ENTRYPOINT /go/bin/web-app --port 8080
```

### nginx configuration and Dockerfile

```ucl
# nginx.conf
events {
    worker_connections 1024;
}

http {
  server_tokens off;
  server {
    listen 80;

    location / {
      proxy_set_header X-Forwarded-For $remote_addr;
      proxy_set_header Host            $http_host;

      # timeout set to 2 seconds
      proxy_read_timeout 2s;
      proxy_connect_timeout 2s;
      proxy_send_timeout 2s;

      proxy_pass http://goservice:8080/;
    }
  }
}
```

And then the Dockerfile:

```Dockerfile
# nginx.Dockerfile
FROM nginx:latest
EXPOSE 80
COPY nginx.conf /etc/nginx/nginx.conf
```

### Docker Compose

The last piece missing is a [Docker Compose](https://docs.docker.com/compose/)
file to help us run these containers:

```yaml
# docker-compose.yaml
version: "3.6"
services:
  goservice:
    build: "server.Dockerfile"
    ports:
      - "8080"
  nginx:
    build: "nginx.Dockerfile"
    ports:
      - "80:80"
    depends_on:
      - "goservice"
```

### Running and testing

After setting up our environment we can test it by running the commands below:

- `docker-compose up --build` to run our containers
- `curl localhost` to make a request to our server

Voilá! The error shows up confirming our theory!

```shell
goservice_1  | 2022/04/07 01:12:14 error writing: write tcp 172.18.0.2:8080->172.18.0.3:56768: write: broken pipe
```

# Conclusion

This was a lot of fun to figure it! As noted by our tests the timeout
configuration of our cluster's reverse proxy was indeed the issue, overriding
the timeout settings with the snippet below solved the issue instantly!

```yaml
apiVersion: configuration.konghq.com/v1
kind: KongIngress
metadata:
  annotations:
    kubernetes.io/ingress.class: "kong"
  name: kong-timeout-conf
proxy:
  connect_timeout: 10000000 # 10 minutes
  protocol: http
  read_timeout: 10000000
  retries: 10
  write_timeout: 10000000
---
apiVersion: v1
kind: Service
metadata:
  annotations:
    konghq.com/override: kong-timeout-conf
```

[kong ingress controller documentation]: https://docs.konghq.com/gateway/1.1.x/reference/proxy/#3-proxying-and-upstream-timeouts
[kong ingress controller]: https://docs.konghq.com/kubernetes-ingress-controller/
