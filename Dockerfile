# ===== Build Stage =====
FROM eclipse-temurin:17-jdk AS build
WORKDIR /app

# Copy Maven wrapper & config
COPY mvnw .
COPY .mvn .mvn
RUN chmod +x mvnw   # 🔥 FIX: Give execute permission

# Copy pom.xml
COPY pom.xml .

# Download dependencies
RUN ./mvnw dependency:go-offline

# Copy source code
COPY src src

# Build the application
RUN ./mvnw package -DskipTests

# ===== Run Stage =====
FROM eclipse-temurin:17-jdk
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
