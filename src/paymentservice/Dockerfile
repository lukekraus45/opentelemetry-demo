# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0


<<<<<<< HEAD
FROM registry.ddbuild.io/images/mirror/node:18-alpine AS build
=======
FROM node:21-alpine AS build
>>>>>>> main

WORKDIR /usr/src/app/

COPY ./src/paymentservice/package*.json ./

RUN apk add --no-cache python3 make g++ && npm ci --omit=dev

RUN  chown root:root -R /usr/src/app/node_modules
# -----------------------------------------------------------------------------

<<<<<<< HEAD
FROM registry.ddbuild.io/images/mirror/node:18-alpine
=======
FROM node:21-alpine
>>>>>>> main

USER node
WORKDIR /usr/src/app/
ENV NODE_ENV production

COPY --chown=node:node --from=build /usr/src/app/node_modules/ ./node_modules/
COPY ./src/paymentservice/ ./
COPY ./pb/demo.proto ./

EXPOSE ${PAYMENT_SERVICE_PORT}
ENTRYPOINT [ "npm", "run", "start" ]
