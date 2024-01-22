# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0
# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# https://mcr.microsoft.com/v2/dotnet/sdk/tags/list
FROM registry.ddbuild.io/images/mirror/dotnet:sdk-8.0.100-1 AS builder
ARG TARGETARCH

WORKDIR /usr/src/app/

COPY ./src/cartservice/ ./
COPY ./pb/ ./src/protos/

RUN \
  RUNTIME_IDENTIIFER=linux-musl-x64; \
  if [ "$(uname -m)" = "aarch64" ]; then RUNTIME_IDENTIIFER=linux-musl-arm64; fi; \
  dotnet restore ./src/cartservice.csproj -r $RUNTIME_IDENTIIFER && \
  dotnet publish ./src/cartservice.csproj -p:PublishSingleFile=true -r $RUNTIME_IDENTIIFER --self-contained true -p:PublishTrimmed=False -p:TrimMode=Link -c Release -o /cartservice --no-restore

# -----------------------------------------------------------------------------

# https://mcr.microsoft.com/v2/dotnet/runtime-deps/tags/list
FROM registry.ddbuild.io/images/mirror/dotnet/runtime-deps:8.0.0-alpine3.18

WORKDIR /usr/src/app/
COPY --from=builder /cartservice/ ./

ENV DOTNET_HOSTBUILDER__RELOADCONFIGONCHANGE=false

# Enable Datadog automatic instrumentation
ENV CORECLR_ENABLE_PROFILING=1
ENV CORECLR_PROFILER={846F5F1C-F9AE-4B07-969E-05C26BC060D8}
ENV CORECLR_PROFILER_PATH=/usr/src/app/datadog/$RUNTIME_IDENTIIFER/Datadog.Trace.ClrProfiler.Native.so
ENV DD_DOTNET_TRACER_HOME=/usr/src/app/datadog

# Run the createLogPath script on Linux to ensure the automatic instrumentation logs are genereated without permission isues
RUN sh /usr/src/app/datadog/createLogPath.sh

EXPOSE ${CART_SERVICE_PORT}
ENTRYPOINT [ "./cartservice" ]
