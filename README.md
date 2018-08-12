# This repository contains scripts to build two separate docker containers one hosting dynamic content (.war) deployed into tomcat and the other container containing static content hosted by nginx and deploy the containers into docker swarm cluster.

Prerequisites :
Workstation : Ubuntu 16.04 server 

#Instructions:

1. Clone this repository into your workstation
2. change directory inside the repo (tw)
3. switch into root user to avoid permission issues.
4. Run the script setup.sh

#What does the script do?

The script will ask for user input that is programmatic aws access credentials - aws access key and aws secret access key, install docker and docker-machine on your workstation and then using docker machine will create 2 ec2 servers on AWS - one server will act as swarm manager and the other as swarm worker. It will then configure the two servers - manager and worker by running the "docker init 
" command via ssh on docker-manager and "docker join" command via ssh on docker node. Then we will configure our current shell to talk to the Docker daemon on the swarm manager VM using "docker-machine env" then build our images locally on the machine and deploy them into local docker registry which will then be used by docker compose to deploy containers into swarm using "docker stack deploy".

#How is the application deployed as containers?

The sample thoughtworks application has two artifacts - one a (.war) file containing dynamic content and the other (.zip) file containing static files such as - css and images. The two artifacts are deployed into two separate containers in docker swarm - the war file is deployed into tomcat container and the zip is hosted by nginx container. Any request for content is proxied via nginx as frontend to the tomcat container running in backend.



