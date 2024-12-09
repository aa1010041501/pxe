#!/bin/bash
echo "-------------------"
echo "Start configuring OS ip address "
sudo wget -P /home/user/ http://10.1.8.5/res/osip.txt
sudo wget -P /home/user/ http://10.1.8.5/res/osip2.txt
sudo wget -P /home/user/ http://10.1.8.5/res/.profile
sudo wget -P /home/user/ http://10.1.8.5/res/.bashrc
sudo wget -P /home/user/ http://10.1.8.5/res/.bash_logout
sudo rm -rf /etc/netplan/*
sudo wget -P /etc/netplan http://10.1.8.5/res/50-cloud-init.yaml
sudo echo "network: {config: disabled}" > /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg
#ipmimac=`./ipmitool lan print  |grep "MAC Address             : "|awk -F 'MAC Address             : ' '{ print $2}'`
#osip=`cat ip.txt  | grep $ipmimac | awk -F '-' '{ print $2}'`
sn=`sudo dmidecode -t 1 | grep Ser| awk -F 'Serial Number: ' '{ print $2}'`
osip=`cat /home/user/osip.txt  | grep "$sn" | awk -F "$sn" '{ print $2}'`
osip2=`cat /home/user/osip2.txt  | grep "$sn" | awk -F "$sn" '{ print $2}'`
sudo sed -i "s/10.1.9.250/$osip/" /etc/netplan/50-cloud-init.yaml 
sudo sed -i "s/10.1.11.250/$osip2/" /etc/netplan/50-cloud-init.yaml 
#sudo netplan apply
#sudo init 0
echo "End configuring OS ip address "
echo "-------------------"
echo "-------------------"
sleep 10
echo "Start download_resources"
sudo wget -P /home/user/ http://10.1.8.5/res/res.tar.gz
sudo tar zxvf /home/user/res.tar.gz -C /home/user 
sudo rm -rf /home/user/res.tar.gz
#sudo init 0
echo "End download_resources"
echo "-------------------"
echo "nvida-install"
sudo dpkg -i /home/user/res/deb/*.deb
sudo /home/user/res/NVIDIA-Linux-x86_64-560.35.03/nvidia-installer -sq
sudo /home/user/res/cuda_12.6.0_560.28.03_linux.run --silent
