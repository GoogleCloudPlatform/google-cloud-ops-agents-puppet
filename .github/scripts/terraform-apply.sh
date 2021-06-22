#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
    echo "\$1 not set, should be an os type"
    exit 1
fi
OS=$1

if [ -z "$2" ]; then
    echo "\$2 not set, should be an agent type"
    exit 1
fi
AGENT_TYPE=$2

if [ -z "$3" ]; then
    echo "\$3 not set, should be an agent version"
    exit 1
fi
VERSION=$3

GIT_REV="$(git rev-parse --short HEAD)"
WORKSPACE="$(echo "${OS}-${AGENT_TYPE}-${VERSION}-${GIT_REV}" | tr -d '.')"

./terraform init >/dev/null
./terraform workspace list | grep "${WORKSPACE}" || ./terraform workspace new "${WORKSPACE}"
./terraform workspace select "${WORKSPACE}"
./terraform apply -auto-approve -var "os=${OS}"

# Let the instance spin up
sleep 45