#!/usr/bin/env bash

if [ -z "$PLATFORM" ]; then
    echo "PLATFORM not set"
    exit 1
fi

if [ -z "$VERSION" ]; then
    echo "VERSION not set"
    exit 1
fi

if [ -z "$AGENT_TYPE" ]; then
    echo "AGENT_TYPE not set"
    exit 1
fi

if [ -z "$ACTION" ]; then
    echo "ACTION not set"
    exit 1
fi

if [ -z "$PROJECT" ]; then
    echo "PROJECT not set"
    exit 1
fi

if [ -z "$ZONE" ]; then
    echo "ZONE not set"
    exit 1
fi

if [ -z "$ADDRESS" ]; then
    echo "ADDRESS not set"
    exit 1
fi

run_puppet() {
    echo "creating dir /etc/puppet/modules"
    ssh "ci@${ADDRESS}" "sudo mkdir -p /etc/puppet/modules" || return

    # single quote $(whoami) to prevent shell expansion, we want to set
    # the owner to the ci user, not the github actions user
    echo "setting perms for permissions /etc/puppet"
    ssh "ci@${ADDRESS}" 'sudo chown -R $(whoami) /etc/puppet' || return

    echo "installing dependencies with r10k"
    rsync ./Puppetfile "ci@${ADDRESS}:/etc/puppet/Puppetfile" || return
    ssh "ci@${ADDRESS}" 'cd /etc/puppet/ && r10k puppetfile install' || return

    echo "copying module to /etc/puppet/modules/cloud_ops"
    rsync -r ./* \
        "ci@${ADDRESS}:/etc/puppet/modules/cloud_ops" \
        --exclude test/ || return

    echo "copying test cases"
    rsync -r test/cases "ci@${ADDRESS}:/tmp" || return

    site_path="/tmp/cases/${PLATFORM}/${AGENT_TYPE}/${VERSION}/${ACTION}/manifests/site.pp"
    module_path="/etc/puppet/modules"

    echo "running puppet apply"
    ssh "ci@${ADDRESS}" sudo /opt/puppetlabs/bin/puppet apply --verbose --modulepath="${module_path}" "${site_path}" || return

    # exit on success
    exit 0
}


# Run up to 3 times, sometimes Github Actions --> GCP connections can be dropped
# causing failures unrelated to the test.
count=3
for i in $(seq ${count}); do
    echo "Puppet attempt ${i} of ${count}"
    run_puppet

    echo "Attempt failed, sleep 10 seconds before trying again"
    sleep 10
done