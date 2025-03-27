# syntax=docker/dockerfile:1.3-labs
# The above syntax directive is required to get support for "RUN --security=insecure"

# Does not work starting with azul/zulu-openjdk:21.0.4-21.36-jdk-crac, error message:
# - Error (criu/cr-restore.c:1518): Can't fork for 7: Read-only file system
# - Error (criu/cr-restore.c:2605): Restoring FAILED.
# - Error (criu/cr-restore.c:1835): Pid 13 do not match expected 7
# FROM azul/zulu-openjdk:21-jdk-crac AS builder

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
RUN java -jar crac-0.0.1-SNAPSHOT.jar &

ADD checkpoint-on-demand.bash checkpoint-on-demand.bash

RUN --security=insecure ./checkpoint-on-demand.bash

FROM azul/zulu-openjdk:21.0.3-21.34-jdk-crac AS runtime

COPY --from=builder checkpoint checkpoint
COPY --from=builder /app/build/libs/crac-0.0.1-SNAPSHOT.jar crac-0.0.1-SNAPSHOT.jar

EXPOSE 8080
ENTRYPOINT ["java", "-XX:CRaCRestoreFrom=checkpoint"]