# ruby-jmeter image to run irfload.rb
FROM base:latest
RUN mkdir /app
COPY scenarios /app/scenarios
COPY entrypoint.sh /app/
COPY reporter.rb /app/reporter.rb
COPY user.properties /opt/jmeter/bin/
CMD ls -l /opt/jmeter/bin

WORKDIR /mnt

# bin/build_jmeter.sh
# docker run -it -v `pwd`:/mnt jmeter:latest scenarios/basic/load.rb --throughput 2 --duration 20 --rampup 1 --url https://www.mockbin.org/request

ENTRYPOINT ["/app/entrypoint.sh"]
