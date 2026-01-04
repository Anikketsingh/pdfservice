# Use Eclipse Temurin 17 as base image (replacement for deprecated openjdk)
FROM eclipse-temurin:17-jdk

# Install Maven
RUN apt-get update && \
    apt-get install -y maven && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy pom.xml first (for dependency caching)
COPY pom.xml .

# Download dependencies (this layer will be cached if pom.xml doesn't change)
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests -B

# Expose port (Render will set PORT env var)
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "target/pdfservice-0.0.1-SNAPSHOT.jar"]

