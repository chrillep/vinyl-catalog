## This is a multi-stage build - we build 2 images:
## The first one we use to build our service binary
## The second one, copies the binary from the first
## image and perform some configuration for production

## FIRST STAGE
## Get the latest Golang version as the base image
## At the time of writing it's Golang 1.18
FROM golang:alpine AS go-build

## Install some required utilities: build-base
## and openssl-dev (necessary for our Server SSL config later on)
## Install some optional utilities: curl, wget, bash, git...
RUN apk add --no-cache tzdata bash wget curl git build-base openssl-dev

## Creates the folder that our application binary will be placed
RUN mkdir -p $$GOPATH/bin

## Install junit and cobertura for coverage reporting
RUN go install github.com/t-yuki/gocover-cobertura@latest
RUN go install github.com/jstemmer/go-junit-report@latest

## Copy the entire content of our services/api directory
## into the Go source path within the image
COPY . /go/src/github.com/thiduzz/vinyl-catalog
## Set the Go source path within the image as the working directory
WORKDIR /go/src/github.com/thiduzz/vinyl-catalog
## Builds the binary for our service and move it to the Go bin path
RUN go install ./cmd/vinyl_catalog/


## SECOND STAGE
## Builds an alpine container and configure
## SSL to connect to our Database
FROM alpine:3.17.0 AS prod-build

## Install openssl-dev and ca-certificate
RUN apk add --update --no-cache ca-certificates openssl-dev

## Download the Certificate Authorities(CA) that AWS RDS recognizes
## Ensure that our image has them registered them by running `update-ca-certificates`
## !! Not performing this will prevent you from communicating with your database !!
RUN wget --no-check-certificate -q -P /usr/local/share/ca-certificates https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem \
  && mv /usr/local/share/ca-certificates/rds-combined-ca-bundle.pem /usr/local/share/ca-certificates/rds-combined-ca-bundle.crt \
  && update-ca-certificates

## Set a folder called App as the working directory
WORKDIR /app
## Copy the binary from the First Stage image into the Second Stage Image
COPY --from=go-build /go/bin/vinyl_catalog /app/
## When the container is booted with this image, run the binary
ENTRYPOINT ./vinyl_catalog