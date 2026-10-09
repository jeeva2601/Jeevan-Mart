FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn -B -DskipTests clean package

FROM tomcat:9.0-jdk17-temurin
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/jeevanmart.war /usr/local/tomcat/webapps/jeevanmart.war
EXPOSE 8080
CMD ["catalina.sh", "run"]