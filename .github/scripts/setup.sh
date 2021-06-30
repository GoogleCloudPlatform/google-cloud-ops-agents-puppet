#!/usr/bin/env bash

# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

export DEBIAN_FRONTEND=noninteractive

if [ -z "$TF_VERSION" ]; then
    echo "TF_VERSION not set"
    exit 1
fi

if [ -z "$PRIVATE_KEY" ]; then
    echo "PRIVATE_KEY not set"
    exit 1
fi

if [ -z "$PUBLIC_KEY" ]; then
    echo "PUBLIC_KEY not set"
    exit 1
fi

# packages
sudo apt-get update >/dev/null
sudo apt-get install -qq -y \
    wget ssh unzip

# pdk
wget https://apt.puppet.com/puppet-tools-release-focal.deb
sudo dpkg -i puppet-tools-release-focal.deb
sudo apt-get update >/dev/null
sudo apt-get install -qq -y pdk

# terraform
wget --quiet -O \
    terraform.zip \
    "https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip"
unzip terraform.zip
chmod +x terraform
mv terraform ./test/terraform/terraform

# handle ssh key
mkdir ~/.ssh
echo "$PRIVATE_KEY" > ~/.ssh/id_rsa
echo "$PUBLIC_KEY" > ~/.ssh/id_rsa.pub
chmod 0600 ~/.ssh/*

# install inspec
curl -L https://omnitruck.cinc.sh/install.sh | sudo bash -s -- -P cinc-auditor -v 4