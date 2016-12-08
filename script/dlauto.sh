#! /bin/bash

for i in $(seq 1576948 101 1577948)
do
        ./logDl.sh $i `expr $i + 100`
done
