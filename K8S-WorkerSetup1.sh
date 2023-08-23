#!/bin/bash

sudo apt update;

sudo apt install -y ca-certificates curl gnupg lsb-release;

# sudo ufw allow from [MASTER_NODE_IP] to any port 10250 proto tcp
sudo ufw allow 30000:32767/tcp;

sudo ufw allow 30000:32767/udp;

sudo ufw allow 10256/tcp;

sudo ufw allow 10250/tcp; # Opens port for the Kubelet API.

sudo ufw allow 30000:32767/tcp; # Opens ports for NodePort services.

sudo ufw reload; #Reloads the firewall to apply the rules.

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

echo "In the following file you need to disable swap with comment(#) like that : #/swapfile"; sudo nano /etc/fstab; 

sudo swapoff -a;  

sudo sysctl --system;

sudo apt update;

sudo apt install -y ca-certificates curl gnupg lsb-release;

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg;

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list;

sudo apt update;

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin;

sudo usermod -aG docker $USER;

echo "Reboot i 5 sec....."; sleep 5; sudo reboot;
