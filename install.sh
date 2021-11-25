#!/bin/bash

# This script aims to install Docker and Kubernetes on a target Ubuntu server (blank)
# Requires root privileges

sudo apt-get update
sudo apt-get upgrade -y
sudo modprobe br_netfilter
sudo apt-get remove -y docker docker-engine docker.io containerd runc
sudo apt-get install -y\
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
newgrp docker # interrupts somewhere starting from here
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update # interrupts somewhere ending in here
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo mv daemon.json /etc/docker/
sudo systemctl restart docker
sudo systemctl restart kubelet

sudo usermod -aG docker $USER
newgrp docker

sudo kubeadm reset
sudo rm -rf /var/lib/etcd

sudo swapoff -a

# TODO check if required
#mkdir -p $HOME/.kube
#sudo cp -y -i /etc/kubernetes/admin.conf $HOME/.kube/config
#sudo chown $(id -u):$(id -g) $HOME/.kube/config


# sudo kubeadm init --apiserver-advertise-address=10.20.0.200 ### TODO variable