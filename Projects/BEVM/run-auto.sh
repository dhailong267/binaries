#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
echo ''
else
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi

# Logo
sleep 1 && curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Logo/logo.sh | bash && sleep 1

# Set walletbevm
if [ ! $Walletbevm ]; then
    read -p "Enter Wallet BEVM: " Walletbevm
    echo 'export Walletbevm='\"${Walletbevm}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

# Update
echo -e "\e[1m\e[32m1. Update... \e[0m" && sleep 1
sudo apt update && sudo apt upgrade -y
sleep 1

# Package
echo -e "\e[1m\e[32m2. Installing package... \e[0m" && sleep 1
sudo apt install curl tar wget clang pkg-config protobuf-compiler libssl-dev jq build-essential protobuf-compiler bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
sleep 1

# Check if Docker is already installed
if command -v docker > /dev/null 2>&1; then
echo "Docker is already installed."
else
# Docker is not installed, proceed with installation
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm $HOME/get-docker.sh
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
docker -v
fi
sleep 1

# Pull image new
echo -e "\e[1m\e[32m4. Pull image... \e[0m" && sleep 1
cd /var/lib
rm -r node_bevm_test_storage
mkdir node_bevm_test_storage
sudo docker pull btclayer2/bevm:v0.1.1
sleep 1

# Run Node
echo -e "\e[1m\e[32m5. Run node... \e[0m" && sleep 1
sudo docker run -d -v /var/lib/node_bevm_test_storage:/root/.local/share/bevm btclayer2/bevm:v0.1.1 bevm "--chain=testnet" "--name=$Walletbevm" "--pruning=archive" --telemetry-url "wss://telemetry.bevm.io/submit 0"
# NAMES=`docker ps | egrep 'bevm/bevm' | awk '{print $10}'`
rm -r $HOME/run-auto.sh

# Command check
echo '====================== SETUP FINISHED ======================'
echo -e "\e[1;32mView the logs from the running: \e[0m\e[1;36msudo docker logs -f containername\e[0m"
echo -e "\e[1;32mCheck the list of containers: \e[0m\e[1;36msudo docker ps -a\e[0m"
echo -e "\e[1;32mStart your avail node: \e[0m\e[1;36msudo docker start containername\e[0m"
echo -e "\e[1;32mRestart your avail node: \e[0m\e[1;36msudo docker restart containername\e[0m"
echo -e "\e[1;32mStop your avail node: \e[0m\e[1;36msudo docker stop containername\e[0m"
echo -e "\e[1;32mRemove avail: \e[0m\e[1;36msudo docker rm containername\e[0m"
echo '============================================================='
