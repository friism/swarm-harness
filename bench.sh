#!/bin/sh

i=0
while [ "$i" -lt $COUNT ]
do
    i=`expr $i + 1 `
    mktemp -u XXXXXX | docker config create $(mktemp -u XXXXXX) - > /dev/null
done
