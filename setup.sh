#!/bin/sh

#user input
echo "Enter your AWS credentials ::"
echo "Enter access key :"
read aws_access_key
echo "Enter secret key :"
read aws_secret_key

echo "## installing docker-ce ##"

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce

echo "## installing docker-machine ##"

base=https://github.com/docker/machine/releases/download/v0.14.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo install /tmp/docker-machine /usr/local/bin/docker-machine


echo "## creating swarm-master node on aws ##"   

docker-machine create --driver amazonec2 --amazonec2-access-key $aws_access_key --amazonec2-secret-key $aws_secret_key --amazonec2-use-private-address --amazonec2-ami ami-759bc50a --amazonec2-open-port 2377  swarm-master

echo "## creating swarm-worker node on aws ##"

docker-machine create --driver amazonec2 --amazonec2-access-key $aws_access_key --amazonec2-secret-key $aws_secret_key --amazonec2-use-private-address --amazonec2-ami ami-759bc50a --amazonec2-open-port 80  swarm-node

echo "## Initialize swarm manager node ##"

docker-machine ssh swarm-master "sudo docker swarm init --listen-addr $(docker-machine ip swarm-master) --advertise-addr $(docker-machine ip swarm-master)"
export worker_token=`docker-machine ssh swarm-master "sudo docker swarm join-token worker -q"`

  
echo "## Join swarm worker node ##"

docker-machine ssh swarm-node "sudo docker swarm join --listen-addr $(docker-machine ip swarm-node) --advertise-addr $(docker-machine ip swarm-node) --token $worker_token $(docker-machine ip swarm-master):2377"

echo "## switch to swarm master environment ##"

docker-machine env swarm-master
eval $(docker-machine env swarm-master)

#echo "## clone the git project"
#git clone https://github.com/das-arghya/tw.git
#cd tw

echo "## build and upload images to local docker repo ##"

docker build -t proxy ./nginx/
docker build -t app ./tomcat/

docker service create --name registry --publish 5000:5000 registry:2

docker tag app localhost:5000/app
docker tag proxy localhost:5000/proxy

docker push localhost:5000/proxy
docker push localhost:5000/app

echo "## Deploy containers in swarm ##"

docker stack deploy --compose-file docker-compose.yml tw
