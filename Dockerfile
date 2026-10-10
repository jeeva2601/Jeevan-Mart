# Multi-stage build for Render: Maven builds a WAR; Tomcat 9 runs it.
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
COPY db ./db
RUN mvn -B -Dmaven.test.skip=true clean package

FROM tomcat:9.0-jdk17-temurin
ENV PORT=8080 \
    JDBC_URL="jdbc:h2:file:/tmp/jeevanmart;DB_CLOSE_ON_EXIT=FALSE;MODE=PostgreSQL" \
    JDBC_USER=sa \
    JDBC_PASSWORD="" \
    AI_CHATBOT_PROVIDER=mock
# Deploy as ROOT so Render's root URL maps directly to the app.
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/jeevanmart.war /usr/local/tomcat/webapps/ROOT.war
COPY render-start.sh /usr/local/bin/render-start.sh
RUN chmod +x /usr/local/bin/render-start.sh
EXPOSE 8080
CMD ["/usr/local/bin/render-start.sh"]
