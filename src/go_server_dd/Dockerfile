# Unless explicitly stated otherwise all files in this repository are licensed
# under the Apache 2.0 License.
#
FROM golang:1.21

WORKDIR /app
COPY ./src/go_server_dd go_server_dd/

WORKDIR /app/go_server_dd
RUN go mod download

RUN go build -o /go_server_dd

CMD [ "/go_server_dd" ]