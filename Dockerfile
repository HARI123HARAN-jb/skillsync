# Build Stage — use Tomcat image so Ant can find server home
FROM tomcat:9.0-jre8 AS build

# Install Ant
RUN apt-get update && apt-get install -y ant && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . .

# Pass Tomcat home so NetBeans build-impl.xml is satisfied
RUN ant -Dj2ee.server.home=/usr/local/tomcat \
    -Dlibs.CopyLibs.classpath=/app/lib/org-netbeans-modules-java-j2seproject-copylibstask.jar \
    default

# Runtime Stage
FROM tomcat:9.0-jre8-alpine
# Clear the default Tomcat app
RUN rm -rf /usr/local/tomcat/webapps/ROOT
# Copy compiled .war as ROOT app
COPY --from=build /app/dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
