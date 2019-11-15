#!/bin/bash

echo ------------------------------
echo "Start with updating package lists"
echo ------------------------------

apt update -y

echo ------------------------------
echo "Update done"
echo ------------------------------
echo "Install Docker"
echo ------------------------------
apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable"
apt install -y docker-ce

echo ------------------------------
echo "Docker installed"
echo ------------------------------
echo "Install K8s"
echo ------------------------------

swapoff -a
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt update
apt install -y kubelet kubeadm kubectl

echo ------------------------------
echo "K8s installed"
echo ------------------------------
