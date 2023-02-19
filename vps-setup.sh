#!/bin/bash

# good for debugging, set --help for more
# set -vx

# use scp to copy this file to the server
# chmod u+x this file to make it executable
# ./vps-setup.sh

echo "Enter username:"
read USERNAME

# run the following only if user doesn't exist
if ! id -u "$USERNAME" >/dev/null 2>&1; then
  echo "User $USERNAME does not exist, creating ..."
  # create the user and give it sudo privilege
  adduser $USERNAME --gecos ""
  usermod -aG sudo $USERNAME

  # copy the script to the new user and print instructions to switch user and re-run it
  cp vps-setup.sh /home/$USERNAME/ && chown $USERNAME: /home/$USERNAME/vps-setup.sh
  echo "Now run the following to switch to the new user and continue with the setup"
  echo "su $USERNAME"
  echo "cd && ~/vps-setup.sh"
  exit 0
fi

# add public ssh key to authorized_keys of the user
echo "SSH Key setup for login"
mkdir .ssh
chmod 700 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

echo "Paste SSH Public Key"
read public_key
echo $public_key >> ~/.ssh/authorized_keys

# setup docker
echo "Docker setup"
sudo apt update
sudo apt install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# test it
sudo docker run hello-world

# allow running docker commands without sudo
sudo groupadd docker
sudo usermod -aG docker $USER

# configure docker to start on boot
sudo systemctl enable docker.service
sudo systemctl enable containerd.service

# generate ssh key to be used with GitHub
echo "SSH Key setup for GitHub"
echo "Enter SSH email"
read ssh_key_email
ssh-keygen -t ed25519 -C $ssh_key_email -q -f "$HOME/.ssh/id_ed25519" -N ""
echo "Add the following public SSH key to GitHub @ https://github.com/settings/ssh/new"
cat ~/.ssh/id_ed25519.pub

read -p "Press any key to continue after adding the key to GitHub"

# clone the repo
echo "Cloning the repo"
git clone git@github.com:mtantawy/vitess-playground.git

# ask the user to logout completely and relogin using ssh to verify setup
echo "Now logout completely and relogin using SSH to verfy setup"
echo "Finally, edit /etc/ssh/sshd_config and disable PermitRootLogin"
