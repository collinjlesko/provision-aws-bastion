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

# if [ -z $1 ]
# then
#     echo "Please provide the number of users as first parameter"
#     echo ""
#     echo "$ ./createUsers.sh 5 ACMpart2018"
#     exit 1
# fi

if [ -z $1 ]
then
    echo "Please provide a password as a second parameter"
    echo ""
    echo "$ ./createUsers.sh ACMpart2018"
    exit 1
fi

if [ -z $2 ]
then
    echo "Please provide the username base as a third parameter"
    echo ""
    echo "$ ./createUsers.sh ACMpart2018 acllab"
    exit 1
fi

# numberofusers=$1
 password=$1
 base=$2

#i=1
#while [ $i -le $numberofusers ]
#do
	echo "ubuntu user file update"
#	sudo useradd -m -s /bin/bash $base$i
    sudo cp -r /etc/skel/. /home/ubuntu/.
    sudo chmod +x /home/$base/forkGitHubRepositories.sh 
    sudo chmod +x /home/$base/defineCredentials.sh
    sudo chmod +x /home/$base/installAnsible.sh
    sudo chmod +x /home/$base/installDockerRegistry.sh
    sudo chmod +x /home/$base/installJenkins.sh
    sudo chmod +x /home/$base/applyK8sConfig.sh
    sudo chmod +x /home/$base/installIstio.sh
    sudo chmod +x /home/$base/add-to-cart.sh
    sudo chmod +x /home/$base/installKeptnBridge.sh
    sudo chmod +x /home/$base/installPrometheusVirtualService.sh
    sudo chmod +x /home/$base/installDynatraceServiceForKeptn.sh
    sudo chmod +x /home/$base/deployDynatraceOperator.sh
    sudo chmod +x /home/$base/fixProduction.sh
    sudo chmod +x -R /home/$base/keptn/
    sudo usermod -aG docker $base
	echo $base:$password | sudo chpasswd
#	i=$((i+1))
#done
