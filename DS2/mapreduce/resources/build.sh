#!/usr/bin/env bash
javac -classpath ~/hw3-mapreduce/hadoop-common-3.1.1.jar:~/hw3-mapreduce/hadoop-mapreduce-client-core-3.1.1.jar \
  -d classes/ MapReduce.java
jar -cvf MapReduce.jar -C classes/ .
