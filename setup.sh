#!/bin/bash

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
DEBIAN_FRONTEND=noninteractive
echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

apt-get install -y apt-transport-https && apt-get update && apt-get install -y --no-install-recommends \
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
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
  && apt-get install -y nodejs \
  && apt-get install -y build-essential \
  && rm -rf /var/lib/apt/lists/*
NODE_OPTIONS=--max_old_space_size=3000
