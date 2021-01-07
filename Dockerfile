# This an example tomcat app build using a multistage build.
# Yes you can build in a multistage dockerfile with a different image than you compile with.
FROM ubuntu:18.04 as compile

# Install ant and jdk
RUN apt-get update && apt-get -y install ant openjdk-8-jdk maven

# Get my source code
COPY webapp /src

WORKDIR /src
RUN mvn package
# No cleanup as this container is discarded

# This stage is a bit silly as we could have staged the tomcat install in the prior stage an 
# there is an offical alpine tomcat image we really should use.
FROM alpine:3.9 as installer
ENV TOMCAT_VERSION 8.0.53

RUN apk add wget
# Really we should mirror this in our network
RUN wget --quiet --no-cookies https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tgz

# We don't care about layers as we are throwing this containers away
RUN tar xf /tmp/tomcat.tgz -C /opt
RUN mv /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat

# Upgrade our packages
RUN apk upgrade --no-cache
# Install just the jre 
RUN apk add --no-cache openjdk8-jre

# Final image
FROM scratch 
# Install the tomcat dir from the tomcat installer stage
COPY --from=installer / /
# Install the war file we built
COPY --from=compile /src/target/sparkjava-hello-world-1.0.war /opt/tomcat/webapps/sparkjava-hello-world-1.0.war

# Run tomcat
CMD /opt/tomcat/bin/catalina.sh run
