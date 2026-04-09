# Build Stage
FROM eclipse-temurin:8-jdk AS build

WORKDIR /app
COPY . .

# Compile all Java sources using lib/* (includes servlet-api jar we added)
RUN mkdir -p build/classes && \
    find src/java -name "*.java" > sources.txt && \
    javac -cp "lib/*" -d build/classes @sources.txt

# Assemble WAR structure manually
RUN mkdir -p dist/war/WEB-INF/classes dist/war/WEB-INF/lib && \
    cp -r web/. dist/war/ && \
    cp -r build/classes/. dist/war/WEB-INF/classes/ && \
    cp lib/*.jar dist/war/WEB-INF/lib/ && \
    cd dist/war && jar -cf ../ROOT.war .

# Runtime Stage
FROM tomcat:9.0-jre8-alpine
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY --from=build /app/dist/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
