# Build Stage
FROM frekele/ant:1.10.3-jdk8 AS build
WORKDIR /app
COPY . .
RUN ant default

# Runtime Stage
FROM tomcat:9.0-jre8-alpine
# Clear the default Tomcat app
RUN rm -rf /usr/local/tomcat/webapps/ROOT
# Copy our compiled .war file to be the ROOT web application
COPY --from=build /app/dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
