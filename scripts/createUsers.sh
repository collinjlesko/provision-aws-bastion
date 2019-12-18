#!/bin/sh

# Prerequisites:
# - put all files that should reside in the users directories in the /etc/skel directory
# - number of workshop participants
# - password for user accounts
#
# Steps:
# - execute script to create users, where the home directory already holds all necessary files
# 
# Example:
# - to create 5 users with password ACMpart2018
#
# $ ./createUsers.sh 5 ACMpart2018

if [ -z $1 ]
then
    echo "Please provide the number of users as first parameter"
    echo ""
    echo "$ ./createUsers.sh 5 ACMpart2018"
    exit 1
fi

if [ -z $2 ]
then
    echo "Please provide a password as a second parameter"
    echo ""
    echo "$ ./createUsers.sh 5 ACMpart2018"
    exit 1
fi

if [ -z $3 ]
then
    echo "Please provide the username base as a third parameter"
    echo ""
    echo "$ ./createUsers.sh 5 ACMpart2018 acllab"
    exit 1
fi

numberofusers=$1
password=$2
base=$3

i=1
while [ $i -le $numberofusers ]
do
	echo "creating user $base$i"
	sudo useradd -m -s /bin/bash $base$i
    sudo chmod +x /home/$base$i/forkGitHubRepositories.sh 
    sudo chmod +x /home/$base$i/defineCredentials.sh
    sudo chmod +x /home/$base$i/installAnsible.sh
    sudo chmod +x /home/$base$i/installDockerRegistry.sh
    sudo chmod +x /home/$base$i/installJenkins.sh
    sudo chmod +x /home/$base$i/applyK8sConfig.sh
    sudo chmod +x /home/$base$i/installIstio.sh
    sudo chmod +x /home/$base$i/add-to-cart.sh
    sudo chmod +x /home/$base$i/installKeptnBridge.sh
    sudo chmod +x /home/$base$i/installPrometheusVirtualService.sh
    sudo chmod +x /home/$base$i/installDynatraceServiceForKeptn.sh
    sudo chmod +x /home/$base$i/deployDynatraceOperator.sh
    sudo chmod +x /home/$base$i/fixProduction.sh
    sudo chmod +x -R /home/$base$i/keptn/
    sudo usermod -aG docker $base$i
	echo $base$i:$password | sudo chpasswd
	i=$((i+1))
done