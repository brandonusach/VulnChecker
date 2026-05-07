# Etapa 1: Construcción
FROM maven:3.9.6-eclipse-temurin-21-alpine AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests -B
# Nombre fijo para la etapa final (Spring Boot genera vulncheckerbackend-0.0.1-SNAPSHOT.jar)
RUN cp /app/target/vulncheckerbackend-0.0.1-SNAPSHOT.jar /app/target/app.jar

# Etapa 2: Ejecución (usuario no root)
FROM eclipse-temurin:21-jre-alpine
RUN addgroup -g 1000 appgroup && adduser -u 1000 -G appgroup -D appuser
WORKDIR /app
COPY --from=build /app/target/app.jar app.jar
RUN chown -R appuser:appgroup /app
USER appuser
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]