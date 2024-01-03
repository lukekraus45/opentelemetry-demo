# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0


<<<<<<< HEAD
FROM registry.ddbuild.io/images/mirror/golang:1.19-alpine AS builder
=======
FROM golang:1.21.4-alpine AS builder
>>>>>>> main

WORKDIR /usr/src/app/

RUN apk add build-base protobuf-dev protoc

COPY ./src/productcatalogservice/ ./
RUN go build -o /go/bin/productcatalogservice/

# -----------------------------------------------------------------------------

FROM registry.ddbuild.io/images/mirror/alpine:latest AS release

WORKDIR /usr/src/app/

COPY ./src/productcatalogservice/products.json ./
COPY --from=builder /go/bin/productcatalogservice/ ./

EXPOSE ${PRODUCT_SERVICE_PORT}
ENTRYPOINT [ "./productcatalogservice" ]
