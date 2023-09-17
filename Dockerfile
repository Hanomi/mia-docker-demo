FROM maven:3.9.4-eclipse-temurin-17-alpine as builder
WORKDIR /workspace/app

COPY pom.xml .
COPY src src

RUN mvn clean package -DskipTests
RUN mkdir -p target/extracted && (java -Djarmode=layertools -jar target/*.jar extract --destination target/extracted)

FROM eclipse-temurin:17-jdk-alpine
VOLUME /tmp
ARG EXTRACTED=/workspace/app/target/extracted
#This problem occurs with a specific sequence of COPY commands in a multistage build.
#More precisely, the bug triggers when there is a COPY instruction producing null effect (for example if the content copied is already present in the destination, with 0 diff), followed immediately by another COPY instruction.
COPY --from=builder ${EXTRACTED}/dependencies/ ./
COPY --from=builder ${EXTRACTED}/spring-boot-loader/ ./
COPY --from=builder ${EXTRACTED}/snapshot-dependencies/ ./
RUN true
COPY --from=builder ${EXTRACTED}/application/ ./
EXPOSE 8080
ENTRYPOINT ["java","org.springframework.boot.loader.JarLauncher"]

