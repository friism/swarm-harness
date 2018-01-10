#!/bin/sh

serviceid=`docker service create -d --mode=global --restart-condition=none --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock -e COUNT=$COUNT friism/bench`

runningtasks=`docker service ps -q --filter "desired-state=running" $serviceid | wc -l`

while [ $runningtasks -gt 0 ]
do
    sleep 1
    runningtasks=`docker service ps -q --filter "desired-state=running" $serviceid | wc -l`
done

docker service rm $serviceid
