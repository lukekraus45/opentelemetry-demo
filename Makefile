# All documents to be used in spell check.
ALL_DOCS := $(shell find . -type f -name '*.md' -not -path './.github/*' -not -path './node_modules/*' | sort)
PWD := $(shell pwd)

TOOLS_DIR := ./internal/tools
MISSPELL_BINARY=bin/misspell
MISSPELL = $(TOOLS_DIR)/$(MISSPELL_BINARY)

# see https://github.com/open-telemetry/build-tools/releases for semconvgen updates
# Keep links in semantic_conventions/README.md and .vscode/settings.json in sync!
SEMCONVGEN_VERSION=0.11.0

# TODO: add `yamllint` step to `all` after making sure it works on Mac.
.PHONY: all
all: install-tools markdownlint misspell

$(MISSPELL):
	cd $(TOOLS_DIR) && go build -o $(MISSPELL_BINARY) github.com/client9/misspell/cmd/misspell

.PHONY: misspell
misspell:	$(MISSPELL)
	$(MISSPELL) -error $(ALL_DOCS)

.PHONY: misspell-correction
misspell-correction:	$(MISSPELL)
	$(MISSPELL) -w $(ALL_DOCS)

.PHONY: markdownlint
markdownlint:
	@if ! npm ls markdownlint; then npm install; fi
	@for f in $(ALL_DOCS); do \
		echo $$f; \
		npx --no -p markdownlint-cli markdownlint -c .markdownlint.yaml $$f \
			|| exit 1; \
	done

.PHONY: install-yamllint
install-yamllint:
    # Using a venv is recommended
	pip install -U yamllint~=1.26.1

.PHONY: yamllint
yamllint:
	yamllint .

# Run all checks in order of speed / likely failure.
.PHONY: check
check: misspell markdownlint
	@echo "All checks complete"

# Attempt to fix issues / regenerate tables.
.PHONY: fix
fix: misspell-correction
	@echo "All autofixes complete"

.PHONY: install-tools
install-tools: $(MISSPELL)
	npm install
	@echo "All tools installed"

.PHONY: build-docker-images
build-docker-images:
	docker compose -f docker-compose.yml build

.PHONY: push-docker-images
push-docker-images:
	docker compose -f docker-compose.yml push

dd_image:
	docker build -f src/adservice/Dockerfile -t otel-demo/adservice . 
	docker build -f src/cartservice/src/Dockerfile -t otel-demo/cartservice . 
	docker build -f src/checkoutservice/Dockerfile -t otel-demo/checkoutservice .
	docker build -f src/currencyservice/Dockerfile -t otel-demo/currencyservice ./src/currencyservice
	docker build -f src/emailservice/Dockerfile -t otel-demo/emailservice ./src/emailservice
	docker build -f src/frontend/Dockerfile -t otel-demo/frontend .
	docker build -f src/paymentservice/Dockerfile -t otel-demo/paymentservice .
	docker build -f src/productcatalogservice/Dockerfile -t otel-demo/productcatalogservice .
	docker build -f src/recommendationservice/Dockerfile -t otel-demo/recommendationservice .
	docker build -f src/shippingservice/Dockerfile -t otel-demo/shippingservice ./src/shippingservice
	docker build -f src/featureflagservice/Dockerfile -t otel-demo/featureflagservice ./src/featureflagservice
	docker build -f src/loadgenerator/Dockerfile -t otel-demo/loadgenerator . 

dd_publish: dd_image
	docker tag otel-demo/adservice registry.ddbuild.io/otel-demo/adservice:v0.1
	docker tag otel-demo/cartservice registry.ddbuild.io/otel-demo/cartservice:v0.1
	docker tag otel-demo/checkoutservice registry.ddbuild.io/otel-demo/checkoutservice:v0.1
	docker tag otel-demo/currencyservice registry.ddbuild.io/otel-demo/currencyservice:v0.1
	docker tag otel-demo/emailservice registry.ddbuild.io/otel-demo/emailservice:v0.1
	docker tag otel-demo/frontend registry.ddbuild.io/otel-demo/frontend:v0.1
	docker tag otel-demo/paymentservice registry.ddbuild.io/otel-demo/paymentservice:v0.1
	docker tag otel-demo/productcatalogservice registry.ddbuild.io/otel-demo/productcatalogservice:v0.1
	docker tag otel-demo/recommendationservice registry.ddbuild.io/otel-demo/recommendationservice:v0.1
	docker tag otel-demo/shippingservice registry.ddbuild.io/otel-demo/shippingservice:v0.1
	docker tag otel-demo/featureflagservice registry.ddbuild.io/otel-demo/featureflagservice:v0.1
	docker tag otel-demo/loadgenerator registry.ddbuild.io/otel-demo/loadgenerator:v0.1
	
	docker push registry.ddbuild.io/otel-demo/adservice:v0.1
	docker push registry.ddbuild.io/otel-demo/cartservice:v0.1
	docker push registry.ddbuild.io/otel-demo/checkoutservice:v0.1
	docker push registry.ddbuild.io/otel-demo/currencyservice:v0.1
	docker push registry.ddbuild.io/otel-demo/emailservice:v0.1
	docker push registry.ddbuild.io/otel-demo/frontend:v0.1
	docker push registry.ddbuild.io/otel-demo/paymentservice:v0.1
	docker push registry.ddbuild.io/otel-demo/productcatalogservice:v0.1
	docker push registry.ddbuild.io/otel-demo/recommendationservice:v0.1
	docker push registry.ddbuild.io/otel-demo/shippingservice:v0.1
	docker push registry.ddbuild.io/otel-demo/featureflagservice:v0.1
	docker push registry.ddbuild.io/otel-demo/loadgenerator:v0.1

k8s_apply_db:
	kubectl apply -f k8s/redis.yaml
	kubectl apply -f k8s/postgres.yaml

k8s_clean_db:
	kubectl delete deployment redis
	kubectl delete deployment postgres
	kubectl delete svc redis
	kubectl delete svc postgres


k8s_apply:
	kubectl apply -f k8s/adservice.yaml
	kubectl apply -f k8s/cartservice.yaml
	kubectl apply -f k8s/checkoutservice.yaml
	kubectl apply -f k8s/currencyservice.yaml
	kubectl apply -f k8s/emailservice.yaml
	kubectl apply -f k8s/featureflagservice.yaml
	kubectl apply -f k8s/frontend.yaml
	kubectl apply -f k8s/paymentservice.yaml
	kubectl apply -f k8s/productcatalogservice.yaml
	kubectl apply -f k8s/recommendationservice.yaml
	kubectl apply -f k8s/shippingservice.yaml

k8s_clean:
	kubectl delete deployment adservice
	kubectl delete deployment cartservice
	kubectl delete deployment checkoutservice
	kubectl delete deployment currencyservice
	kubectl delete deployment emailservice
	kubectl delete deployment featureflagservice
	kubectl delete deployment frontend
	kubectl delete deployment paymentservice
	kubectl delete deployment productcatalogservice
	kubectl delete deployment recommendationservice
	kubectl delete deployment shippingservice
	kubectl delete svc adservice
	kubectl delete svc cartservice
	kubectl delete svc checkoutservice
	kubectl delete svc currencyservice
	kubectl delete svc emailservice
	kubectl delete svc featureflagservice
	kubectl delete svc frontend
	kubectl delete svc paymentservice
	kubectl delete svc productcatalogservice
	kubectl delete svc recommendationservice
	kubectl delete svc shippingservice


