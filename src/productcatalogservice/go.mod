module github.com/opentelemetry/opentelemetry-demo/src/productcatalogservice

go 1.22.0

require (
	github.com/open-feature/go-sdk v1.10.0
	github.com/open-feature/go-sdk-contrib/hooks/open-telemetry v0.3.1
	github.com/open-feature/go-sdk-contrib/providers/flagd v0.1.22
	github.com/sirupsen/logrus v1.9.3
	go.opentelemetry.io/contrib/instrumentation/google.golang.org/grpc/otelgrpc v0.49.0
	go.opentelemetry.io/contrib/instrumentation/runtime v0.49.0
	go.opentelemetry.io/otel v1.24.0
	go.opentelemetry.io/otel/exporters/otlp/otlpmetric/otlpmetricgrpc v1.24.0
	go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracegrpc v1.24.0
	go.opentelemetry.io/otel/sdk v1.24.0
	go.opentelemetry.io/otel/sdk/metric v1.24.0
	go.opentelemetry.io/otel/trace v1.24.0
	google.golang.org/grpc v1.62.0
	google.golang.org/grpc/cmd/protoc-gen-go-grpc v1.3.0
	google.golang.org/protobuf v1.32.0
)

require (
	buf.build/gen/go/open-feature/flagd/connectrpc/go v1.12.0-20231031123731-ac2ec0f39838.1 // indirect
	buf.build/gen/go/open-feature/flagd/grpc/go v1.3.0-20231031123731-ac2ec0f39838.2 // indirect
	buf.build/gen/go/open-feature/flagd/protocolbuffers/go v1.31.0-20231031123731-ac2ec0f39838.2 // indirect
	connectrpc.com/connect v1.14.0 // indirect
	connectrpc.com/otelconnect v0.7.0 // indirect
	github.com/cenkalti/backoff/v4 v4.2.1 // indirect
	github.com/diegoholiveira/jsonlogic/v3 v3.4.0 // indirect
	github.com/fsnotify/fsnotify v1.7.0 // indirect
	github.com/go-logr/logr v1.4.1 // indirect
	github.com/go-logr/stdr v1.2.2 // indirect
	github.com/grpc-ecosystem/grpc-gateway/v2 v2.18.0 // indirect
	go.opentelemetry.io/otel/exporters/otlp/otlptrace v1.20.0 // indirect
	go.opentelemetry.io/otel/metric v1.20.0 // indirect
	go.opentelemetry.io/proto/otlp v1.0.0 // indirect
	google.golang.org/genproto/googleapis/api v0.0.0-20230822172742-b8732ec3820d // indirect
	google.golang.org/genproto/googleapis/rpc v0.0.0-20230822172742-b8732ec3820d // indirect
)

require (
	go.opentelemetry.io/contrib/instrumentation/google.golang.org/grpc/otelgrpc v0.46.0
	go.opentelemetry.io/otel v1.20.0
	go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracegrpc v1.20.0
	golang.org/x/sys v0.14.0 // indirect
	golang.org/x/text v0.13.0 // indirect
)
