FROM openjdk:17-buster

RUN apt-get update -y; apt-get install curl -y

WORKDIR /home/otel
RUN curl -Lo opentelemetry-javaagent.jar https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar
COPY ./src/java_client_otel/ java_client_otel/
WORKDIR /home/otel/java_client_otel
RUN ./gradlew shadowJar

ENTRYPOINT ["java","-javaagent:../opentelemetry-javaagent.jar",  "-jar" , "app/build/libs/app-all.jar"]
