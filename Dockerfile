# Build Stage
FROM eclipse-temurin:8-jdk AS build

WORKDIR /app
COPY . .

# Compile all Java sources using lib/* (includes servlet-api jar)
RUN mkdir -p build/classes && \
    find src/java -name "*.java" > sources.txt && \
    javac -cp "lib/*" -d build/classes @sources.txt

# Assemble WAR - only copy essential runtime JARs (skip duplicates & build tools)
RUN mkdir -p dist/war/WEB-INF/classes dist/war/WEB-INF/lib && \
    cp -r web/. dist/war/ && \
    cp -r build/classes/. dist/war/WEB-INF/classes/ && \
    cp lib/mysql-connector-java-5.1.49-bin.jar dist/war/WEB-INF/lib/ && \
    cp lib/javax.mail.jar dist/war/WEB-INF/lib/ && \
    cp lib/activation.jar dist/war/WEB-INF/lib/ && \
    cp lib/commons-fileupload-1.4.jar dist/war/WEB-INF/lib/ && \
    cp lib/commons-io-1.4.jar dist/war/WEB-INF/lib/ && \
    cp lib/apache-commons-lang.jar dist/war/WEB-INF/lib/ && \
    cp lib/itextpdf-5.5.13.2.jar dist/war/WEB-INF/lib/ && \
    cp lib/bcprov.jar dist/war/WEB-INF/lib/ && \
    cp lib/json-20231013.jar dist/war/WEB-INF/lib/ && \
    cp lib/twilio-7.20.0-jar-with-dependencies.jar dist/war/WEB-INF/lib/ && \
    cp lib/zxing.jar dist/war/WEB-INF/lib/ && \
    cp lib/zxing-javase.jar dist/war/WEB-INF/lib/ && \
    cp lib/jstl-standard.jar dist/war/WEB-INF/lib/ && \
    cp lib/commons-codec-1.15.jar dist/war/WEB-INF/lib/ && \
    cd dist/war && jar -cf ../ROOT.war .

# Runtime Stage
FROM tomcat:9.0-jre8-alpine

# Disable the AJP connector (not needed on Render, causes noise)
RUN sed -i '/Connector port="8009"/d' /usr/local/tomcat/conf/server.xml && \
    sed -i 's/port="8005"/port="-1"/' /usr/local/tomcat/conf/server.xml

# Limit JVM memory to stay within Render free tier (512MB)
ENV CATALINA_OPTS="-Xms64m -Xmx384m -XX:MetaspaceSize=64m -XX:MaxMetaspaceSize=128m -XX:+UseG1GC"

RUN rm -rf /usr/local/tomcat/webapps/ROOT \
    /usr/local/tomcat/webapps/docs \
    /usr/local/tomcat/webapps/examples \
    /usr/local/tomcat/webapps/manager \
    /usr/local/tomcat/webapps/host-manager

COPY --from=build /app/dist/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
