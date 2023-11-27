package main

import (
	"net/http"
	"os"

	log "github.com/sirupsen/logrus"

	"go.opentelemetry.io/otel"
	httptrace "gopkg.in/DataDog/dd-trace-go.v1/contrib/net/http"
	ddotel "gopkg.in/DataDog/dd-trace-go.v1/ddtrace/opentelemetry"
	"gopkg.in/DataDog/dd-trace-go.v1/ddtrace/tracer"
)

func initLogger() {
	log.SetFormatter(&log.JSONFormatter{})
	log.SetOutput(os.Stdout)
	log.SetLevel(log.InfoLevel)
}

func main() {
	initLogger()

	tracer.Start(
		tracer.WithRuntimeMetrics(),
	)
	defer tracer.Stop()

	// OTel
	provider := ddotel.NewTracerProvider()
	defer provider.Shutdown()
	otel.SetTracerProvider(provider)
	otelTracer := provider.Tracer("dd-otel")

	// Create a traced mux router
	mux := httptrace.NewServeMux()
	// Continue using the router as you normally would.
	mux.HandleFunc("/inject", func(w http.ResponseWriter, r *http.Request) {
		_, otelSpan := otelTracer.Start(r.Context(), "otel_api_span")
		log.WithFields(log.Fields{
			"dd.span_id":  otelSpan.SpanContext().SpanID().String(),
			"dd.trace_id": otelSpan.SpanContext().TraceID().String(),
			"service":     "go-server-dd",
			"env":         "otel-ingest-staging",
		}).Info("Doing work in server")
		otelSpan.End()
		w.Write([]byte("Work Done"))
	})
	if err := http.ListenAndServe("0.0.0.0:8082", mux); err != nil {
		log.Fatal(err)
	}
}
