# Use OpenJDK 17 as base image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy Maven wrapper files
COPY mvnw .
COPY .mvn .mvn
RUN chmod +x mvnw

# Copy pom.xml first (for dependency caching)
COPY pom.xml .

# Download dependencies (this layer will be cached if pom.xml doesn't change)
RUN ./mvnw dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN ./mvnw clean package -DskipTests -B

# Expose port (Render will set PORT env var)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "target/pdfservice-0.0.1-SNAPSHOT.jar"]

