# Cloud Operations Puppet Agents Testing

## Overview

This repo leverages the following for integration testing:

- [Google Compute Engine](https://cloud.google.com/compute): Test instances
- [Github Actions](https://github.com/features/actions): Continuous integration
- [Packer](https://www.packer.io/): Build test instance base images
- [Terraform](https://www.terraform.io/): Deploy test instances
- [Inspec](https://github.com/inspec/inspec): Perform validation

## Google Compute Engine

Google Compute Engine hosts the testing environment, ensure the following APIs are enabled in the project:

```bash
gcloud services enable compute.googleapis.com
gcloud services enable storage-api.googleapis.com
```

Create a service account with the following roles:

- Compute Admin
- Service Account User

Create a service account json key, which will be referenced during Github Actions configuration.

## Github Actions

Github actions requires several secrets. Navigate to the repositories secrets and add the following:

- **GCP_PROJECT_ID**: Google Cloud project_id
- **GCP_SA_KEY**: Google Cloud service account json key
- **SSH_PRIVATE_KEY**: keypair private key
- **SSH_PUBLIC_KEY**: keypair public key

#### Keypair

You can generate an SSH keypair with `ssh-keygen`. This keypair will be used for Puppet and Inspec's ssh connectivity.

## Packer

Packer is used to "bake" `puppet` and `gcloud sdk` into base images. Using base images allows tests to be repeatable, reliable, fast.

Base images must be built prior to running tests. Install `packer` and then run the following commands in the `test/packer` directory:
```bash
./build.sh ubuntu-2004-lts
./build.sh ubuntu-1804-lts
./build.sh ubuntu-1604-lts
./build.sh debian-10
./build.sh debian-9
./build.sh centos-s8
./build.sh centos-8
./build.sh centos-7
./build.sh rhel-8
./build.sh rhel-7
./build.sh sles-12
./build.sh sles-15
```

#### Requirements

Packer will require access to Google APIs. This [guide provides](https://cloud.google.com/build/docs/building/build-vm-images-with-packer) examples on how to setup your working environment.

## Terraform

Terraform is used by the Github Actions workflow, no setup configuraton is required. The configuration can be found in `test/terraform`.

## Inspec

Inspec is used for running integration tests. Test cases are found in `test/cases`. No setup configuraton is required. 

The directory structure is as follows:

```bash
test/cases/{platform}/{agent_type}/{version}/{action}/
```

For example, ops-agent version 1.04 on linux:
```bash
test/cases/linux/ops-agent/1.0.4/install/
```

Tests with specific versions will:
1. Install the agent
2. Upgrade the agent
3. Uninstall the agent
4. Install the agent with a custom configuration

Inspec output will look like this:
```bash

Profile: tests from test/cases/linux/ops-agent/1.0.4/custom_config/spec/spec.rb (tests from test.cases.linux.ops-agent.1.0.4.custom_config.spec.spec.rb)
Target:  ssh://ci@34.75.191.137:22

  Service google-cloud-ops-agent.target
     ✔  is expected to be installed
     ✔  is expected to be enabled
     ✔  is expected to be running
  System Package google-cloud-ops-agent
     ✔  is expected to be installed
     ✔  version is expected to match /1.0.4/
  File /etc/google-cloud-ops-agent/config.yaml
     ✔  is expected to exist
     ✔  owner is expected to eq "root"
     ✔  group is expected to eq "root"
     ✔  mode is expected to cmp == "0644"
     ✔  sha256sum is expected to eq "202256588869d4efc115317829c0435cdd8caf2e876f259509d552e974b4f907"

Test Summary: 10 successful, 0 failures, 0 skipped
```
