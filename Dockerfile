FROM golang:1.15-alpine as builder

RUN apk update \
    && apk add --no-cache git ca-certificates make bash 

RUN go env -w GO111MODULE=on && \
    go env -w GOPROXY=https://goproxy.cn,direct

WORKDIR /app

RUN git clone https://github.com/ouqiang/gocron.git \
    && cd gocron \
    && CGO_ENABLED=0 make node

FROM ubuntu:focal


WORKDIR /app

COPY --from=builder /app/gocron/bin/gocron-node .


EXPOSE 5921


ENTRYPOINT ["/app/gocron-node"]
