FROM golang:1.11 AS builder

WORKDIR /go/src/github.com/upmc-enterprises/registry-creds
COPY . .
RUN { apk add make || { apt update && apt install make; }; } && make build
RUN make test

FROM alpine:latest

RUN apk add --update ca-certificates && \
  rm -rf /var/cache/apk/*

COPY --from=builder /go/src/github.com/upmc-enterprises/registry-creds/registry-creds registry-creds

ENTRYPOINT ["/registry-creds"]
