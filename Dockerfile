# ruby-jmeter image to run irfload.rb
FROM alpine:3.10

ARG JMETER_VERSION="5.2.1"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN	${JMETER_HOME}/bin
ENV	JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

# Install extra packages
# See https://github.com/gliderlabs/docker-alpine/issues/136#issuecomment-272703023
# Change TimeZone TODO: TZ still is not set!
ARG TZ="America/New_York"
RUN apk update
RUN apk upgrade
RUN apk add ca-certificates
RUN update-ca-certificates
RUN apk add --update openjdk8-jre nss tzdata curl unzip bash \
	&& mkdir -p /tmp/dependencies  \
	&& curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& rm -rf /tmp/dependencies

RUN apk add build-base ruby-dev ruby ruby-bundler ruby-io-console libffi-dev zlib-dev ruby-json
RUN rm -rf /var/cache/apk/*
RUN gem install rdoc --no-document && gem install ruby-jmeter json slop

RUN ln -s $JMETER_HOME /opt/jmeter
RUN mkdir /app
COPY scenarios /app/scenarios
COPY entrypoint.sh /app/
COPY user.properties /opt/jmeter/bin/
CMD ls -l /opt/jmeter/bin

WORKDIR /mnt

# docker build -t jmeter:latest .
# docker run -it -v `pwd`:/mnt jmeter:latest scenarios/basic/load.rb --throughput 2 --duration 20 --rampup 1 --url https://www.mockbin.org/request

ENTRYPOINT ["/app/entrypoint.sh"]
