# Use official OpenJDK image
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Set environment variables
ENV MAVEN_OPTS="-Xmx1024m"
ENV BASE_URL=http://demo-app:3100/api
ENV KARATE_ENV=dev

# Install Maven and other dependencies
RUN apt-get update && \
    apt-get install -y maven curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy Maven configuration
COPY pom.xml ./

# Download dependencies (this layer will be cached)
RUN mvn dependency:resolve

# Copy source code
COPY src ./src

# Create directories for reports
RUN mkdir -p target/surefire-reports target/karate-reports

# Set permissions
RUN chmod -R 755 target

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://demo-app:3100/api/inventory || exit 1

# Default command
CMD ["mvn", "test"]
