#!/bin/bash
set -exo pipefail

# To make it easier for build and release pipelines to run apt,
# configure apt-get to not require confirmation (assume the -y argument by default)
DEBIAN_FRONTEND=noninteractive
echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

sudo apt-get autoremove
sudo apt-get clean
sudo apt-get update

# Install essential packages.
sudo apt-get install -y apt-transport-https && sudo apt-get update && sudo apt-get install -y \
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
  wget

# Install Node.js LTS
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
  && sudo apt-get install -y nodejs \
  && sudo apt-get install -y build-essential

# Fix npm install speeds
# See: https://stackoverflow.com/a/39799741/6178885
sudo rm /etc/resolv.conf
sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
sudo bash -c 'echo "[network]" > /etc/wsl.conf'
sudo bash -c 'echo "generateResolvConf = false" >> /etc/wsl.conf'
sudo chattr +i /etc/resolv.conf

# Install yq (to read yaml files)
wget -q https://github.com/mikefarah/yq/releases/download/v4.24.5/yq_linux_amd64 -O /usr/bin/yq \
  && chmod +x /usr/bin/yq

# Install Azure CLI
curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
  && az extension add -n azure-devops

# Install Chrome
sudo apt-get update
sudo apt-get install -y fonts-liberation libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 libcairo2 libcups2 libgbm1 libgtk-3-0 libpango-1.0-0 libxcomposite1 libxdamage1 libxfixes3 libxkbcommon0 libxrandr2 xdg-utils
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb
