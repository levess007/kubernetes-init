#!/bin/bash

if [ $1 -n ]
then
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
echo "K8s Master Node Initialization"
echo ------------------------------

sysctl net.bridge.bridge-nf-call-iptables=1
kubeadm init --apiserver-advertise-address $1
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
else
	echo "usage: install.sh <IP_ADDR>"
fi
