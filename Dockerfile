FROM registry.access.redhat.com/ubi8/openjdk-11:latest AS builder
USER root
WORKDIR /tmp
# Download and install Maven manually to avoid package manager issues
RUN curl -fsSL https://archive.apache.org/dist/maven/maven-3/3.8.8/binaries/apache-maven-3.8.8-bin.tar.gz | tar xzf - -C /opt && \
    ln -s /opt/apache-maven-3.8.8 /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/local/bin/mvn
ENV MAVEN_HOME=/opt/maven
ENV PATH="${MAVEN_HOME}/bin:${PATH}"
COPY . .
RUN mvn --no-transfer-progress clean package -DskipTests

FROM registry.access.redhat.com/ubi8/openjdk-11:latest
COPY --from=builder /tmp/target/nationalparks.jar /opt
CMD java -jar /opt/nationalparks.jar
EXPOSE 8080
