# Written by Dan Stolts http://ITProGuru.com
/*
Install and configure the following...
1.	Gnome and XRDP https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-classic-remote-desktop/
2.	R-Base and R-Studio. (Current version installed is 0.98.1062) https://www.datascienceriot.com/how-to-install-r-in-linux-ubuntu-16-04-xenial-xerus/kris/
3.	SMB client (to mount Azure Files) https://azure.microsoft.com/en-in/documentation/articles/storage-how-to-use-files-linux/#mount-the-file-share
4.	Azure Linux Diagnostic Extension https://github.com/Azure/azure-linux-extensions/tree/master/Diagnostic

Ports needed: 
ssh: 22
docker: 2376
RDP: 3389
HTTP: 80
HTTPS: 443


Commands should be run individually, 
   not tested and will not likely work trying to run entire script
*/

#Create Base VM + Install Docker on base...
#See CreateDockerRegistry.ps1
# Base Ubuntu16 Image
# Install Docker
#Login to Ubuntu VM
#Deploy Docker
#Leveragin Instructions from: https://itproguru.com/wp-admin/post.php?post=95423

curl -fsSL https://get.docker.com/ | sh
sudo docker ps -a
sudo docker images
sudo docker info

# Create a new container  https://docs.docker.com/engine/reference/commandline/create/ 
sudo docker run -t -i ubuntu:latest /bin/bash 

apt-get update
apt-get install -y xubuntu-desktop
exit

# Get the Container ID... (lowecase L below)
sudo docker ps –l

sudo docker commit <ContainerIDGoesHere> ubuntu16:desktop

sudo docker run -it ubuntu16:desktop


sudo apt-get update

# 1.	Gnome and XRDP
#       https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-linux-classic-remote-desktop/

#Install xfce Desktop - required for RDP to Desktop
#sudo apt-get update
#sudo apt-get install ubuntu-desktop
sudo apt-get install -y xubuntu-desktop


# Install xrdp for Remote Desktop (RDP)
sudo apt-get install -y xrdp
echo xfce4-session >~/.xsession

exit

# Get the Container ID... (lowecase L below)
sudo docker ps –a
sudo docker commit <ContainerIDGoesHere> ubuntu16:rdp
sudo docker run -it ubuntu16:rdp

# 2.	R-Base and R-Studio. (Current version installed is 0.98.1062)
# https://www.datascienceriot.com/how-to-install-r-in-linux-ubuntu-16-04-xenial-xerus/kris/

# Add Repository
sudo echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | sudo tee -a /etc/apt/sources.list

#Add R to Ubuntu Keyring
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -

# Install R-Base
sudo apt-get -y update
sudo apt-get install -y r-base r-base-dev

# Install R-Studio
sudo apt-get install -y gdebi-core
wget https://download1.rstudio.org/rstudio-0.99.896-amd64.deb
sudo gdebi -n rstudio-0.99.896-amd64.deb
rm rstudio-0.99.896-amd64.deb

# SMB client (to mount Azure Files)
sudo mkdir /mnt/userdrive
sudo apt-get install -y cifs-utils
exit

# Get the Container ID... (lowecase L below)
sudo docker ps -a
sudo docker commit <ContainerIDGoesHere> ubuntu16:rstudio
sudo docker 
sudo docker run -d -i -t ubuntu16:rstudio
sudo docker tag ubuntu16:rstudio rstudio/ubuntu16:rstudio

# 3.	SMB client (to mount Azure Files)
# https://azure.microsoft.com/en-in/documentation/articles/storage-how-to-use-files-linux/#mount-the-file-share
storageAccount='StorageAccountNamne'
fileshare='users'
userFolder='UserNameGoesHere'
storageKey='StorageAccountKeyGoesHere'

sudo mkdir /mnt/userdrive
sudo apt-get install -y cifs-utils
sudo mount -t cifs //'+storageAccount+'.file.core.windows.net/'+fileshare+'/'+userFolder+' /mnt/userdrive -o vers=3.0,username='+storageAccount+',password='+storageKey+'
#sudo mount -t cifs //myaccountname.file.core.windows.net/mysharename ./mymountpoint -o vers=3.0,username=myaccountname,password=StorageAccountKeyEndingIn==,dir_mode=0777,file_mode=0777

