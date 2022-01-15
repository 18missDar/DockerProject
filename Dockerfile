FROM maven:3.6.0-jdk-8 AS build
WORKDIR /spring-petclinic

COPY pom.xml ./
COPY src ./src

RUN mvn clean package

FROM openjdk:8-jre-slim

COPY --from=build /spring-petclinic/target/spring-petclinic-*.jar /petclinic.jar

CMD ["java", "-jar", "petclinic.jar"]
