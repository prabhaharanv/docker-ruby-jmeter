#!/bin/bash
# docker entrypoint for running ruby jmeter in docker
set -e
freeMem=`awk '/MemFree/ { print int($2/1024) }' /proc/meminfo`
s=$(($freeMem/10*8))
x=$(($freeMem/10*8))
n=$(($freeMem/10*2))
export JVM_ARGS="-Xmn${n}m -Xms${s}m -Xmx${x}m"

mkdir -p /mnt/output
rm -rf /mnt/jmeter.jtl /mnt/output/*
# run your ruby-jmeter script with args
cd /app
ruby $@
mv jmeter.* /mnt/output/
mv ruby-jmeter.jmx /mnt/output/
# create report
cd /mnt/output
/opt/jmeter/bin/jmeter -g jmeter.jtl -o html