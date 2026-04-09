# Build Stage — JDK8 with Ant to compile the project
FROM eclipse-temurin:8-jdk AS build

# Install Ant
RUN apt-get update && apt-get install -y ant && rm -rf /var/lib/apt/lists/*

# Download a minimal Tomcat so Ant has a j2ee server home with servlet-api.jar
RUN mkdir -p /tomcat/lib && \
    curl -L "https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/3.1.0/javax.servlet-api-3.1.0.jar" \
    -o /tomcat/lib/javax.servlet-api-3.1.0.jar

WORKDIR /app
COPY . .

# Build the WAR
RUN ant -Dj2ee.server.home=/tomcat \
    -Dlibs.CopyLibs.classpath=/app/lib/org-netbeans-modules-java-j2seproject-copylibstask.jar \
    default

# Runtime Stage — lightweight Tomcat to serve the WAR
FROM tomcat:9.0-jre8-alpine
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY --from=build /app/dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
