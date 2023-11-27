#!/usr/bin/env bash

# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0

# This script is used to deploy collector on demo account cluster

set -euo pipefail
IFS=$'\n\t'
set -x

clusterName=$CLUSTER_NAME
clusterArn=$CLUSTER_ARN
region=$REGION

install_reinvent_demos() {
  # Set the namespace and release name
  release_name="opentelemetry-demo"

  # Deploy zookeeper which is not a default component.
  sed -i "s/PLACEHOLDER_COMMIT_SHA/v$CI_COMMIT_SHORT_SHA/g" ./src/go_server_dd/deployment-staging.yaml
  kubectl apply -f ./src/go_server_dd/deployment-staging.yaml -n otel-ingest-staging
  
  # Deploy java order producer which is not a default component.
  sed -i "s/PLACEHOLDER_COMMIT_SHA/v$CI_COMMIT_SHORT_SHA/g" ./src/java_client_otel/deployment-staging.yaml
  kubectl apply -f ./src/java_client_otel/deployment-staging.yaml -n otel-staging
}

###########################################################################################################

aws eks --region "${region}" update-kubeconfig --name "${clusterName}"
kubectl config use-context "${clusterArn}"

install_reinvent_demos