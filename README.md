# Kubernetes Cluster Installation Guide

# Requirements
1. Minimal installation of Ubuntu 22.04.
2. Minimum 3GB RAM.
3. Minimum 3 processor cores.
4. Minimum 35 GB disk space.
5. Sudo user with admin rights.
6. Internet connectivity on each node ("Bridge adapter" in the VM settings). 

# Master Node installation
To build Master Node run the 2 scripts like this:
```sh
./K8S-MasterSetup1.sh
```
It reboots the server, wait for the server to come back up and run:
'''sh
./K8S-MasterSetup2.sh
'''
# Install Worker Node
To build a Worker Node run the 2 scripts like this:
'''sh
./K8S-WorkerSetup1.sh
'''
It reboots the server, wait for the server to come back up and run:
'''sh
./K8S-WorkerSetup2.sh
'''
# Initialize the Node
If you use virtual machines there are times when there are communication problems, to solve this reboot the server by running the script:
'''sh
./Initialize-Node
'''
Read the explanation before selecting the Node to enter as input to the script.
