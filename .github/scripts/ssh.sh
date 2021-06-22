#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
    echo "\$1 not set, should be instance name"
    exit 1
fi
INSTANCE=$1

if [ -z "$PROJECT" ]; then
    echo "PROJECT not set"
    exit 1
fi

if [ -z "$ZONE" ]; then
    echo "ZONE not set"
    exit 1
fi

ADDRESS=$(gcloud --project "${PROJECT}" compute instances describe --zone "${ZONE}" "${INSTANCE}" --format=json | jq -r '.networkInterfaces[0].accessConfigs[0].natIP')

ssh_key() {
    rm -f ~/.ssh/known_hosts

    echo "adding target ${ADDRESS} to known hosts"
    # foreever, timeout is handled by Github Actions pipeline
    while :
    do
        ssh-keyscan "${ADDRESS}" >> ~/.ssh/known_hosts && break
        sleep 5
    done

    # sleep again to allow ssh metadata key to populate
    sleep 20

    echo "finished adding ${ADDRESS} to known hosts"
}

ssh_key