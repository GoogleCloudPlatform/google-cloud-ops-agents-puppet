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

describe service('google-cloud-ops-agent.target') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
end

describe package('google-cloud-ops-agent') do
    it { should be_installed }
    its('version') { should match /1.0.4/ }
end

describe file('/etc/google-cloud-ops-agent/config.yaml') do
    it { should exist }
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
    its('sha256sum') { should eq '202256588869d4efc115317829c0435cdd8caf2e876f259509d552e974b4f907' }
end

