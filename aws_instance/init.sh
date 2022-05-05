#!/bin/bash

sudo mkfs.ext4 /dev/nvme1n1 
sudo mkdir /mnt/nvme
sudo echo "/dev/nvme1n1    /mnt/nvme    ext4    defaults    0 0" | sudo tee -a /etc/fstab
sudo mount -a
if [[ $? != 0 ]]; then
    sudo docker-compose down
    sudo mkfs.ext4 /dev/nvme1n1 
    sudo mount -a
fi
sudo tune2fs -r 0 /dev/nvme1n1
sudo apt update -y 
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - 
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable" 
sudo apt update -y 
sudo apt-get install docker-ce -y 
sudo systemctl start docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
cd /home/ubuntu/
sudo docker-compose up -d
##########################################
#add_user
sudo useradd -d /home/usr -m -s /bin/bash \
-c FullName,Phone,OtherInfo usr -p $(echo "belkapass" | openssl passwd -1 -stdin)
sudo usermod -aG sudo usr
sudo sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo service ssh restart
###########################################
#node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz # Replace on new verison
tar -xvzf node_exporter-1.1.2.linux-amd64.tar.gz
cp node_exporter-1.1.2.linux-amd64/node_exporter /usr/local/bin/
/usr/sbin/useradd --no-create-home --shell /bin/false node_exporter
chown node_exporter:node_exporter /usr/local/bin/node_exporter
#Add
tee /etc/systemd/system/node_exporter.service <<"EOF"
[Unit]
Description=Node Exporter
[Service]
User=node_exporter
Group=node_exporter
EnvironmentFile=-/etc/sysconfig/node_exporter
ExecStart=/usr/local/bin/node_exporter $OPTIONS
[Install]
WantedBy=multi-user.target
EOF
#Create
mkdir /etc/sysconfig
tee /etc/sysconfig/node_exporter <<"EOF"
OPTIONS="--collector.processes --collector.systemd"
EOF
chown node_exporter:node_exporter /etc/sysconfig/node_exporter
#Delete
rm node_exporter-1.1.2.linux-amd64.tar.gz
rm -rf node_exporter-1.1.2.linux-amd64
#Run
sudo systemctl daemon-reload && \
sudo systemctl enable node_exporter && \
sudo systemctl start node_exporter  
#Downloading
wget https://github.com/ncabatoff/process-exporter/releases/download/v0.7.5/process-exporter-0.7.5.linux-amd64.tar.gz # Replace on new verison
tar -xvzf process-exporter-0.7.5.linux-amd64.tar.gz
cp process-exporter-0.7.5.linux-amd64/process-exporter /usr/local/bin/
/usr/sbin/useradd --no-create-home --shell /bin/false process-exporter
chown process-exporter:process-exporter /usr/local/bin/process-exporter
#Add
tee /etc/systemd/system/process-exporter.service <<"EOF"
[Unit]
Description=Process Exporter
[Service]
User=process-exporter
Group=process-exporter
Type=simple
ExecStart=/usr/local/bin/process-exporter --config.path /etc/sysconfig/process-exporter.yml
[Install]
WantedBy=multi-user.target
EOF
tee /etc/sysconfig/process-exporter.yml <<"EOF"
process_names:
  - name: "{{.Comm}}"
    cmdline:
    - '.+'
EOF
chown process-exporter:process-exporter /etc/sysconfig/process-exporter.yml
#Delete
rm process-exporter-0.7.5.linux-amd64.tar.gz
rm -rf process-exporter-0.7.5.linux-amd64
#Run
sudo systemctl daemon-reload && \
sudo systemctl enable process-exporter && \
sudo systemctl start process-exporter && \
sudo systemctl status process-exporter && sudo systemctl status node_exporter 
####################################
