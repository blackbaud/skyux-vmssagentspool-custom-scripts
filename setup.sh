#!/bin/bash

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
DEBIAN_FRONTEND=noninteractive
echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

apt-get update

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
  wget

# Install Node.js LTS
curl -fsSL https://deb.nodesource.com/setup_lts | bash - \
  && apt-get install -y nodejs \
  && apt-get install -y build-essential
NODE_OPTIONS=--max_old_space_size=3000

# Fix npm install speeds
# sudo rm /etc/resolv.conf
# sudo bash -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'
# sudo bash -c 'echo "[network]" > /etc/wsl.conf'
# sudo bash -c 'echo "generateResolvConf = false" >> /etc/wsl.conf'
# sudo chattr +i /etc/resolv.conf

# Install Azure CLI
curl -LsS https://aka.ms/InstallAzureCLIDeb | bash \
  && az extension add -n azure-devops

# Install dependencies for Chrome
apt-get update && apt-get install -y \
  fonts-liberation \
  libasound2 \
  libatk-bridge2.0-0 \
  libatk1.0-0 \
  libatspi2.0-0 \
  libcairo2 \
  libcups2 \
  libdbus-1-3 \
  libdrm2 \
  libgbm1 \
  libglib2.0-0 \
  libgtk-3-0 \
  libnspr4 \
  libnss3 \
  libpango-1.0-0 \
  libx11-6 \
  libxcb-dri3-0 \
  libxcb1 \
  libxcomposite1 \
  libxdamage1 \
  libxext6 \
  libxfixes3 \
  libxkbcommon0 \
  libxrandr2

# Install Chrome
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
  dpkg -i google-chrome-stable_current_amd64.deb && \
  apt -f install -y && \
  rm -f google-chrome-stable_current_amd64.deb

# Install chromedriver
CHROME_VERSION="google-chrome-stable" && \
  CHROME_BIN=$(which google-chrome) && \
  CHROME_MAJOR_VERSION=$(google-chrome -version | sed -E "s/.* ([0-9]+)(\.[0-9]+){3}.*/\1/") && \
  CHROME_DRIVER_VERSION=$(wget --no-verbose -O - "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_MAJOR_VERSION}") && \
  echo "Using chromedriver version: $CHROME_DRIVER_VERSION" && \
  wget --no-verbose -O /tmp/chromedriver_linux64.zip https://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip && \
  rm -rf /opt/selenium/chromedriver && \
  unzip /tmp/chromedriver_linux64.zip -d /opt/selenium && \
  rm /tmp/chromedriver_linux64.zip && \
  mv /opt/selenium/chromedriver /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION && \
  chmod 755 /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION && \
  ln -fs /opt/selenium/chromedriver-$CHROME_DRIVER_VERSION /usr/bin/chromedriver
