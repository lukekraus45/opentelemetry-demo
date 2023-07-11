# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0


FROM registry.ddbuild.io/images/java:corretto-17 AS builder

WORKDIR /usr/src/app/

COPY ./src/adservice/gradlew* ./src/adservice/settings.gradle* ./src/adservice/build.gradle ./
COPY ./src/adservice/gradle ./gradle

RUN ./gradlew
RUN ./gradlew downloadRepos

COPY ./src/adservice/ ./
COPY ./pb/ ./proto
RUN ./gradlew installDist -PprotoSourceDir=./proto

# -----------------------------------------------------------------------------

FROM registry.ddbuild.io/images/java:corretto-17

ARG version=1.24.0
WORKDIR /usr/src/app/

COPY --from=builder /usr/src/app/ ./
RUN curl -Lo /usr/src/app/dd-java-agent.jar https://dtdg.co/latest-java-tracer
RUN chmod 644 /usr/src/app/dd-java-agent.jar
ENV JAVA_TOOL_OPTIONS=-javaagent:/usr/src/app/dd-java-agent.jar

EXPOSE ${AD_SERVICE_PORT}
ENTRYPOINT [ "./build/install/opentelemetry-demo-ad-service/bin/AdService" ]
