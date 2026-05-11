# Use a lightweight JRE base image
FROM openjdk:17-jdk-slim

# Set working directory inside container
WORKDIR /app

# Copy the built JAR from Maven target folder
COPY target/*.jar app.jar

# Expose application port (adjust if your app uses a different port)
EXPOSE 8080

# Run the JAR
ENTRYPOINT ["java", "-jar", "app.jar"]

