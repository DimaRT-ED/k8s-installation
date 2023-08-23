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

echo -n "Return to the "Master Node" machine.

echo -e "1. Return to the \033[1mMaster Node\033[0m machine.\n\n2. Copy the contents of the \033[1mkubeadm-join\033[0m command that we received from the Master Node. If you have lost this content, you can generate new content by running the following command on the Master Node:\n\n\033[1mkubeadm token create --print-join-command\033[0m\n\n3. After obtaining the join command, prepend it with \033[1msudo\033[0m and append the flag \033[1m--cri-socket=unix:///var/run/cri-dockerd.sock\033[0m.\n\nFor example, the modified join command should look like:\n\n\033[1msudo kubeadm join 192.168.0.10:6443 --token nzy73q.3s2ig8r2ue09wrjy --discovery-token-ca-cert-hash sha256:0866420e1833c5a0710c92712d56468b4576b8bd8f00c381232dd993d89a0246 --cri-socket=unix:///var/run/cri-dockerd.sock\033[0m\n\n4. Copy the modified command, then paste and execute it in the terminal of each of the \033[1mWorker Nodes\033[0m (the two workers we created).\n\n5. After joining all the worker nodes, switch back to the \033[1mMaster Node\033[0m terminal and verify the nodes by running:\n\n\033[1mkubectl get nodes\033[0m"
