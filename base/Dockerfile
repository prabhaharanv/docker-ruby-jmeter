# ruby-jmeter base image used by ../Dockerfile
FROM alpine:3.12

ARG JMETER_VERSION="5.3"
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
RUN apk add --update openjdk8-jre nss tzdata curl unzip bash
RUN	mkdir -p /tmp/dependencies  \
	&& curl -L ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& rm -rf /tmp/dependencies

RUN apk add build-base ruby-dev ruby ruby-bundler ruby-io-console libffi-dev zlib-dev ruby-json
RUN rm -rf /var/cache/apk/*
RUN gem install rdoc --no-document && gem install ruby-jmeter json slop terminal-table

RUN ln -s $JMETER_HOME /opt/jmeter
