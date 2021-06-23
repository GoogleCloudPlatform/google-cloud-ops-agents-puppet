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

run_inspec() {
    # Inspec is Apache 2.0 licensed, but requires that the license
    # is accepted https://github.com/inspec/inspec/blob/master/LICENSE
    export CHEF_LICENSE="accept-no-persist"

    inspec exec \
        "test/cases/${PLATFORM}/${AGENT_TYPE}/${VERSION}/${ACTION}/spec/spec.rb" \
        -t "ssh://ci@${ADDRESS}" \
        -i ~/.ssh/id_rsa || return

    # exit on success
    exit 0
}

# Run up to 3 times, sometimes Github Actions --> GCP connections can be dropped
# causing failures unrelated to the test.
count=3
for i in $(seq ${count}); do
    echo "Inspec attempt ${i} of ${count}"
    run_inspec

    echo "Attempt failed, sleep 10 seconds before trying again"
    sleep 10
done

# Exit non zero on failure
exit 1