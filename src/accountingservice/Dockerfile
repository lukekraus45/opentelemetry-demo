# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0


<<<<<<< HEAD
FROM registry.ddbuild.io/images/mirror/golang:1.19-alpine AS builder
=======
FROM golang:1.21.4-alpine AS builder
>>>>>>> main
WORKDIR /usr/src/app/

COPY ./src/accountingservice/ ./
RUN go build -o /go/bin/accountingservice/

# -----------------------------------------------------------------------------

FROM alpine

WORKDIR /usr/src/app/

COPY --from=builder /go/bin/accountingservice/ ./

ENTRYPOINT [ "./accountingservice" ]
