# Synthetic swarm tests

This is a harness for testing how quickly data can be pushed into swarm. The harness creates lots of config objects. The time resolution is currently 1s.

## Building

```
docker build --target runner -t friism/bench:runner .
docker build --target bench -t friism/bench .
```

## Running

This will only worker on a manager-only cluster.

Create 3000 config objects per node:

```
time docker run --rm -e COUNT=3000 -v /var/run/docker.sock:/var/run/docker.sock friism/bench:runner
```

## Results

I was primarily interested in learning what happens with swarm object creation throughput as the number of managers increases. To that end I created a 3 and a 7 manager cluster using Docker for AWS (notionally only 5 managers are supported, but it's simple to change the template to setup 7 managers). Docker for AWS spreads managers across AZs so there's _some_ inter-manager network latency.

In this test we'll time the time to create a total 21000 configs on 3 and 7 manager clusters (with no workers):

```
~ $ time docker run --rm -e COUNT=7000 -v /var/run/docker.sock:/var/run/docker.sock friism/bench:runner
0k45zs31ryqghdp3sl5vhw06j
real    2m 41.90s
user    0m 0.00s
sys     0m 0.03s
~ $ docker node ls
ID                            HOSTNAME                                      STATUS              AVAILABILITY        MANAGER STATUS
s6aj8dpcrea1wwv2fuetac9ye     ip-172-31-13-221.us-west-2.compute.internal   Ready               Active              Leader
l0pfb1tiz24p1hdtp2q4w2jsu     ip-172-31-20-194.us-west-2.compute.internal   Ready               Active              Reachable
nc4efvb50pivtb8h53h23jbh4 *   ip-172-31-46-174.us-west-2.compute.internal   Ready               Active              Reachable
~ $ docker config ls -q | wc -l
20986
```

```
~ $ time docker run --rm -e COUNT=3000 -v /var/run/docker.sock:/var/run/docker.sock friism/bench:runner
z31d4rfjkgqvc10ygjyaz5ne6
real    2m 6.75s
user    0m 0.01s
sys     0m 0.02s
~ $ docker node ls
ID                            HOSTNAME                                      STATUS              AVAILABILITY        MANAGER STATUS
lev55n5mnma1xykkmc5boxsoe     ip-172-31-9-27.us-west-2.compute.internal     Ready               Active              Reachable
wovnno3t917bxmwb61gzcbmdn     ip-172-31-12-238.us-west-2.compute.internal   Ready               Active              Reachable
s78a1sz28tfcb6x2mrokifj6b *   ip-172-31-19-142.us-west-2.compute.internal   Ready               Active              Reachable
krvvv02z7ucactkwbl5an4otu     ip-172-31-21-80.us-west-2.compute.internal    Ready               Active              Leader
pavl50y7w6okdvxkgevkzlhih     ip-172-31-21-85.us-west-2.compute.internal    Ready               Active              Reachable
v1zis7v4hvluk7wh7aci46c53     ip-172-31-34-115.us-west-2.compute.internal   Ready               Active              Reachable
uxgaq0gejeikr7sosyd4r8c0b     ip-172-31-39-205.us-west-2.compute.internal   Ready               Active              Reachable
~ $ docker config ls -q | wc -l
20987
```

As we can see, we can actually get more stuff jammed in with 7 managers. The harness primarily stresses Docker, and does not spend a lot of time in the shell script.
