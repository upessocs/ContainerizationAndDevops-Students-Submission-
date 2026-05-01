# ---------- Stage 1: Build Stage ----------
FROM maven:3.9-eclipse-temurin-11 AS builder

WORKDIR /app

# Copy pom first for better caching
COPY pom.xml .
RUN mvn -q -e -B -DskipTests dependency:go-offline

# Copy source code
COPY src ./src

# Build the jar
RUN mvn -q -DskipTests package


# ---------- Stage 2: Runtime Stage ----------
FROM eclipse-temurin:11-jre

WORKDIR /app

# Copy jar from builder
COPY --from=builder /app/target/multistage-demo-1.0.jar app.jar

# Create non-root user (more portable way)
RUN adduser --disabled-password --gecos "" myuser
USER myuser

# Run application
CMD ["java", "-jar", "app.jar"]
