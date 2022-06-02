#!/bin/bash
set -exo pipefail

# To make it easier for build and release pipelines to run apt,
# configure apt-get to not require confirmation (assume the -y argument by default)
DEBIAN_FRONTEND=noninteractive
echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

sudo apt-get update

# Install essential packages.
sudo apt-get install -y apt-transport-https && sudo apt-get update && sudo apt-get install -y --no-install-recommends \
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
  && apt-get install -y nodejs \
  && apt-get install -y build-essential
NODE_OPTIONS=--max_old_space_size=3000

# Fix npm install speeds
# See: https://stackoverflow.com/a/39799741/6178885
# sudo rm /etc/resolv.conf
# sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
# sudo bash -c 'echo "[network]" > /etc/wsl.conf'
# sudo bash -c 'echo "generateResolvConf = false" >> /etc/wsl.conf'
# sudo chattr +i /etc/resolv.conf

# Install yq
wget -q https://github.com/mikefarah/yq/releases/download/v4.24.5/yq_linux_amd64 -O /usr/bin/yq \
  && chmod +x /usr/bin/yq

# Install Azure CLI
curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
  && rm -rf /var/lib/apt/lists/* \
  && az extension add -n azure-devops

# # Install dependencies for Chrome
# apt-get update && apt-get install -y --no-install-recommends \
#   fonts-liberation \
#   libasound2 \
#   libatk-bridge2.0-0 \
#   libatk1.0-0 \
#   libatspi2.0-0 \
#   libcairo2 \
#   libcups2 \
#   libdbus-1-3 \
#   libdrm2 \
#   libgbm1 \
#   libglib2.0-0 \
#   libgtk-3-0 \
#   libnspr4 \
#   libnss3 \
#   libpango-1.0-0 \
#   libx11-6 \
#   libxcb1 \
#   libxcomposite1 \
#   libxdamage1 \
#   libxext6 \
#   libxfixes3 \
#   libxkbcommon0 \
#   libxrandr2 \
#   && rm -rf /var/lib/apt/lists/*

# # Install Chrome
# wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
#   dpkg -i google-chrome-stable_current_amd64.deb && \
#   apt -f install -y && \
#   rm -f google-chrome-stable_current_amd64.deb

# # Install chromedriver
# CHROME_VERSION="google-chrome-stable" && \
#   CHROME_BIN=$(which google-chrome) && \
#   CHROME_MAJOR_VERSION=$(google-chrome -version | sed -E "s/.* ([0-9]+)(\.[0-9]+){3}.*/\1/") && \
#   CHROME_DRIVER_VERSION=$(wget --no-verbose -O - "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_MAJOR_VERSION}") && \
#   echo "Using chromedriver version: $CHROME_DRIVER_VERSION" && \
#   wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip && \
#   rm -rf /opt/selenium/chromedriver && \
#   unzip /tmp/chromedriver_linux64.zip -d /opt/selenium && \
#   rm /tmp/chromedriver_linux64.zip && \
#   mv /opt/selenium/chromedriver /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION && \
#   chmod 755 /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION && \
#   ln -fs /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION /usr/bin/chromedriver

sudo apt-get install -y fonts-liberation libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 libcairo2 libcups2 libgbm1 libgtk-3-0 libpango-1.0-0 libxcomposite1 libxdamage1 libxfixes3 libxkbcommon0 libxrandr2 xdg-utils
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome*.deb
