#!/usr/bin/env bash

sleep 20

# set -o errexit
# set -o nounset
# set -o pipefail

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

# Install Docker
sudo apt-get  -yq update
sudo apt-get  -yq install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get  -yq update
sudo apt-get  -yq install docker-ce docker-ce-cli containerd.io

# MARIADB
# sudo apt-get  -yq install software-properties-common dirmngr apt-transport-https
# sudo apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'
# sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el,s390x] https://mirror.docker.ru/mariadb/repo/10.6/ubuntu focal main'
# sudo apt -yq update
# sudo apt -yq install mariadb-server

export MAINDB="${MAINDB}"
export PASSWDDB="${PASSWDDB}"
mysql -hwpdb.cluster-ro-c9nmurf5weua.eu-central-1.rds.amazonaws.com -u$MAINDB -p$PASSWDDB -e "CREATE DATABASE $MAINDB;"
# # mysql -hwpdb.cluster-ro-c9nmurf5weua.eu-central-1.rds.amazonaws.com -uwpdb -p -e "CREATE DATABASE $MAINDB;"
# mysql -e "CREATE USER $MAINDB@$MAINDB IDENTIFIED BY '$PASSWDDB';"
# mysql -e "GRANT ALL PRIVILEGES ON $MAINDB.* TO '$MAINDB'@'%' IDENTIFIED BY '$PASSWDDB';"
# mysql -e "FLUSH PRIVILEGES;"

# # sudo usermod -aG docker "$USER" && /usr/bin/env bash
# sudo systemctl restart mariadb

# /etc/mysql/mariadb.conf.d/50-server.cnf
# bind-address            = 0.0.0.0

# DOCKER 
sudo mkdir -pv /mnt/efs/wp
sudo docker volume create --opt type=none --opt device=/mnt/efs/wp --opt o=bind wp
# sudo docker volume create --opt type=none --opt device=/mnt/HC_Volume_15900200 --opt o=bind wp


# sudo docker run --rm --mount 'source=wp,target=/var/www/html' -p 8080:80 -e WORDPRESS_DB_HOST=65.108.154.35:3306 -e WORDPRESS_DB_USER=$MAINDB -e WORDPRESS_DB_PASSWORD=$PASSWDDB -e WORDPRESS_DB_NAME=wpdb -e WORDPRESS_DEBUG=1 --name wptest -d wordpress
sudo docker run --rm --mount 'source=wp,target=/var/www/html' -p 8080:80 -e WORDPRESS_DB_HOST=wpdb.cluster-ro-c9nmurf5weua.eu-central-1.rds.amazonaws.com -e WORDPRESS_DB_USER=$MAINDB -e WORDPRESS_DB_PASSWORD=$PASSWDDB -e WORDPRESS_DB_NAME=wpdb -e WORDPRESS_DEBUG=1 --name wptest -d wordpress
