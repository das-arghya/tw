#!/bin/sh
for i in 1 2
do
curl -I $(docker-machine ip swarm-master)
done
