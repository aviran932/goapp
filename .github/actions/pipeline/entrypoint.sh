#!/bin/bash

echo "Hello from brnach: ${GITHUB_REF##*/}"
apt-get update -y
apt-get -y install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update -y
apt-get install docker-ce docker-ce-cli containerd.io -y
docker build -t ${INPUT_DOCKER_USERNAME}/${INPUT_DOCKER_REPOSITORY}:${GITHUB_REF##*/}-${GITHUB_SHA} .
docker login -u ${INPUT_DOCKER_USERNAME} -p ${INPUT_DOCKER_SECRET}
docker push ${INPUT_DOCKER_USERNAME}/${INPUT_DOCKER_REPOSITORY}:${GITHUB_REF##*/}-${GITHUB_SHA}
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
apt-get install unzip -y
unzip awscliv2.zip
./aws/install
aws configure set aws_access_key_id ${INPUT_AWS_ACCESS_KEY_ID}
aws configure set aws_secret_access_key ${INPUT_AWS_SECRET_ACCESS_KEY}
aws configure set default.region us-east-2
apt-get update -y
apt-get install -y apt-transport-https ca-certificates curl
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update -y
apt-get install -y kubectl 
aws eks --region ${INPUT_REGION} update-kubeconfig --name ${INPUT_CLUSTER_NAME}
cat deployment.yaml | sed "s/IMAGE_NAME/${INPUT_DOCKER_USERNAME}\/${INPUT_DOCKER_REPOSITORY}:${GITHUB_REF##*/}-${GITHUB_SHA}/g" | kubectl apply -f -
kubectl apply -f service.yaml