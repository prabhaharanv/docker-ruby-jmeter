# docker-jmeter
A good reference for running load tests with ruby jmeter and docker

## Local development

Here are some steps if you wish to use the load testing scripts locally

### Install dependencies

You will need openjdk 1.8, Ruby 2.2+, Jmeter (https://jmeter.apache.org/download_jmeter.cgi)

### Setup

```
gem install ruby-jmeter slop json
export JMETER_BIN=PATH_TO_JMETER_BIN
```

### Run
```
ruby scenarios/basic/load.rb -t 120 -d 20 -r 1 -u https://www.mockbin.org/request
``` 

### Run with docker
```
docker run -it -v `pwd`:/mnt jmeter:latest scenarios/basic/load.rb -t 120 -d 20 -r 1 -u https://www.mockbin.org/request

```
The -v option mounts your current dir, so you can inspect the output files from ruby-jmeter and jmeter
- jmeter.log (runtime info)
- jmeter.jtl csv file with actual results (one request per line)
- ruby-jmeter.jmx the XML file that ruby-jmeter creates as an input for jmeter itself

### Create an html report

```
$JMETER_BIN/jmeter -g jmeter.jtl -o output
open output/index.html
```

