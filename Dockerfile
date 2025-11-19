FROM registry.access.redhat.com/ubi8/openjdk-11:latest AS builder
WORKDIR /tmp
# Install Maven
RUN microdnf install -y maven && microdnf clean all
COPY . .
RUN mvn --no-transfer-progress clean package -DskipTests

FROM registry.access.redhat.com/ubi8/openjdk-11:latest
COPY --from=builder /tmp/target/nationalparks.jar /opt
CMD java -jar /opt/nationalparks.jar
EXPOSE 8080
