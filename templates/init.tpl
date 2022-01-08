#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# Build and install AWS EFS Utilities
sudo apt-get update -yq
sudo apt-get -yq install git binutils
git clone https://github.com/aws/efs-utils /home/"$USER"/efs-utils
cd /home/"$USER"/efs-utils
./build-deb.sh
sudo apt-get -yq install ./build/amazon-efs-utils*deb

# Mount EFS
sudo mkdir /mnt/efs
efs_id="${efs_id}"
sudo mount -t efs $efs_id:/ /mnt/efs
# sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport 192.168.7.4:/ /mnt/efs

# Edit fstab so EFS automatically loads on reboot
echo "$efs_id:/ /efs efs defaults,_netdev 0 0" | sudo tee --append /etc/fstab
