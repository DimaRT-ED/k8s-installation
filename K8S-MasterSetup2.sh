#!/bin/bash

sudo apt update;

sudo git clone https://github.com/Mirantis/cri-dockerd.git;

sudo chown -R $USER:$USER cri-dockerd;

sudo apt install golang-go;

export GOPATH=$HOME/go;

export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin;

source ~/.bashrc;


cd cri-dockerd;

mkdir bin;

go build -o bin/cri-dockerd;

sudo mkdir -p /usr/local/bin;

sudo install -o root -g root -m 0755 bin/cri-dockerd /usr/local/bin/cri-dockerd;

sudo su -c 'cp -a packaging/systemd/* /etc/systemd/system && \
sed -i -e "s,/usr/bin/cri-dockerd,/usr/local/bin/cri-dockerd," /etc/systemd/system/cri-docker.service && \
systemctl daemon-reload && \
systemctl enable cri-docker.service && \
systemctl enable --now cri-docker.socket'


curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -;

echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list;

sudo apt update;

sudo apt install -y kubelet=1.26.0-00 kubeadm=1.26.0-00 kubectl=1.26.0-00;

sudo apt-mark hold kubelet kubeadm kubectl;

sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --cri-socket=unix:///var/run/cri-dockerd.sock;
 
echo -e "Copy Paste the following command to the CLI:\n\n\033[1m1. mkdir -p \$HOME/.kube\033[0m\n\033[1m2. sudo cp -i /etc/kubernetes/admin.conf \$HOME/.kube/config\033[0m\n\033[1m3. sudo chown \$(id -u):\$(id -g) \$HOME/.kube/config\033[0m\n\033[1m4. kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml\033[0m"
