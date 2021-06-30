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
./terraform workspace select "${WORKSPACE}"
./terraform destroy -auto-approve -var "os=${OS}"