#!/bin/bash

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
DEBIAN_FRONTEND=noninteractive
echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

sudo apt-get update

# Install essential packages.
apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  jq \
  git \
  npm \
  zip \
  unzip \
  iputils-ping \
  libcurl4 \
  libicu66 \
  libunwind8 \
  netcat \
  libssl1.0 \
  gnupg2 \
  wget \
  && rm -rf /var/lib/apt/lists/*

# Install Node.js LTS
curl -fsSL https://deb.nodesource.com/setup_lts | bash - \
  && apt-get install -y nodejs \
  && apt-get install -y build-essential \
  && rm -rf /var/lib/apt/lists/*
NODE_OPTIONS=--max_old_space_size=3000

# Fix npm install speeds
sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
sudo bash -c 'echo "[network]" > /etc/wsl.conf'
sudo bash -c 'echo "generateResolvConf = false" >> /etc/wsl.conf'
sudo chattr +i /etc/resolv.conf

# Install Azure CLI
curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
  && rm -rf /var/lib/apt/lists/* \
  && az extension add -n azure-devops

# Install Chrome.
sudo apt-get update
sudo apt install python-pip
pip install simplejson
pip install bs4
pip install selenium
sudo apt-get install -y libasound2 libnspr4 libnss3 libxss1 xdg-utils unzip libappindicator1 fonts-liberation
apt-get -f install
wget http://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb

# Install chromedriver.
CHROME_VERSION=$(curl https://chromedriver.storage.googleapis.com/LATEST_RELEASE)
wget https://chromedriver.storage.googleapis.com/$CHROME_VERSION/chromedriver_linux64.zip
unzip chromedriver_linux64.zip
sudo mv chromedriver /usr/bin/chromedriver
sudo chown root:root /usr/bin/chromedriver
sudo chmod +x /usr/bin/chromedriver
