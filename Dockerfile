FROM eclipse-temurin:17-jre
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*
RUN curl -L "https://archive.apache.org/dist/ignite/2.14.0/apache-ignite-2.14.0-bin.zip" -o ignite.zip && \
    unzip ignite.zip -d /opt && \
    mv /opt/apache-ignite-2.14.0-bin /opt/ignite && \
    rm ignite.zip
WORKDIR /opt/ignite
COPY ignite-config.xml /opt/ignite/config/
ENV IGNITE_JVM_OPTS="-Xms512m -Xmx2G -XX:MaxDirectMemorySize=1G \
                     -Djava.net.preferIPv4Stack=true \
                     -DIGNITE_PERFORMANCE_SUGGESTIONS_DISABLED=true"
EXPOSE 10800 47500-47509 47100 11211
CMD ["./bin/ignite.sh", "config/ignite-config.xml"]
