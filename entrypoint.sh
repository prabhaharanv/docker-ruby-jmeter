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
cd /mnt/output
echo START: `date` > /mnt/output/results.txt
ruby /app/$@
# generate reports (including statistic.json)
/opt/jmeter/bin/jmeter -g jmeter.jtl -o html
# output a simple txt/markdown report
echo "+++RESULTS+++"
ruby /app/reporter.rb /mnt/output/html/statistics.json 
# write report to file
echo END:   `date` >> /mnt/output/results.txt
ruby /app/reporter.rb /mnt/output/html/statistics.json >> /mnt/output/results.txt
cp /mnt/output/html/statistics.json /mnt/output/
