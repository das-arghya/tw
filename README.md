# This repository contains scripts to build two separate docker containers one hosting dynamic content (.war) deployed into tomcat and the other container containing static content (.zip) hosted by nginx and deploy the containers into docker swarm cluster.

#Hardware and software used in the demo stack :

* Workstation : Ubuntu 16.04 server (aws ec2)
* Cloud Infra provider : Amazon web services
* AMI (for generating two swarm machines ): ami-759bc50a [Ubuntu 16.04]
* Virtualization / Clustering engine: Docker swarm
* Application container : Apache tomcat (port:8080 - not exposed outside of host)
* Static content Hosting Container: Nginx (port:80)

#Instructions:

1. Clone this repository into your workstation
2. change directory inside the repo (tw)
3. switch into root user to avoid permission issues.
4. Run the script "setup.sh"
5. Run the "test.sh" to check the application deployment
6. The application should be available via nginx on default port 80.

WARNING!
Sometimes the provisioning of ec2 machines on AWS fails on apt-get, it happens randomly maybe 1 out of 3,4 times. I was not able to find a root cause for the issue, could track it to this:
https://github.com/docker/machine/issues/3990

*Only solution for now is to delete the machines using "docker-machine rm" and re-provision the machines using the script.

Okay lets move on :

#What does the script(setup.sh) do?

The script will ask for user input that is programmatic aws access credentials - aws access key and aws secret access key then it will install docker and docker-machine on your workstation and then using docker machine will create 2 ec2 servers on AWS - one server will act as swarm manager and the other as swarm worker. It will then configure the two servers - manager and worker by running the "docker init 
" command via ssh on docker-manager and "docker join" command via ssh on docker node. Then we will configure our current shell to talk to the Docker daemon on the swarm manager VM using "docker-machine env" after that build our images locally on the swarm-master machine and deploy them into local docker registry which will then be used by docker compose to deploy containers into swarm using "docker stack deploy".

#How are the application artifacts deployed as containers?

The sample thoughtworks application has two artifacts - one a (.war) file containing dynamic content and the other (.zip) file containing static files such as - css and images. The two artifacts are deployed into two separate containers in docker swarm - the war file is deployed into tomcat container and the zip is hosted by nginx container which has a configuration file that can be created to direct where requests should go, thereby acting as a reverse proxy. Any request for content is proxied via nginx as frontend to the tomcat container running in backend.



