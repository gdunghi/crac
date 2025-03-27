# syntax=docker/dockerfile:1.3-labs
FROM amazoncorretto:21.0.5 AS builder
RUN yum install -y tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Bangkok /etc/localtime && \
    echo "Asia/Bangkok" > /etc/timezone

WORKDIR /app

COPY . /app/
ENV GRADLE_USER_HOME=/app/.gradle

ARG version=2.11.0
RUN /app/gradlew clean assemble
RUN cp /app/build/libs/crac-0.0.1-SNAPSHOT.jar crac-0.0.1-SNAPSHOT.jar

ADD checkpoint-on-demand.bash checkpoint-on-demand.bash

RUN --security=insecure ./checkpoint-on-demand.bash

FROM azul/zulu-openjdk:21.0.3-21.34-jdk-crac AS runtime

COPY --from=builder checkpoint checkpoint
COPY --from=builder /app/build/libs/crac-0.0.1-SNAPSHOT.jar crac-0.0.1-SNAPSHOT.jar

EXPOSE 8080
ENTRYPOINT ["java", "-XX:CRaCRestoreFrom=checkpoint"]