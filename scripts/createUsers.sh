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
    echo "Please provide a user as a first parameter"
    echo ""
    echo "$ ./createUsers.sh ACMpart2018"
    exit 1
fi

 base=$1

sudo cp -r /etc/skel/. /home/$base/
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
sudo sed -i 's/%sudo\s*ALL=(ALL:ALL)\s*ALL/%sudo   ALL=(ALL) NOPASSWD:ALL/g' /etc/sudoers
