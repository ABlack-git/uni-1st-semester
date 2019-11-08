#!/usr/bin/env bash
hadoop fs -copyToLocal \
  /user/f191_zakhaand/hw3/output/part-r-00000 \
  output.txt
hadoop fs -rm -r /user/f191_zakhaand/hw3/output/