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

describe service('google-fluentd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
end

describe file('/etc/google-fluentd/google-fluentd.conf') do
    it { should exist }
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
    its('sha256sum') { should eq '9f83e16f70a9b014cb7631f68eab6bab9f05e992d4db7873ed26ff28b087a533' }
end

describe file('/etc/google-fluentd/plugin/plugin.rb') do
    it { should exist }
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
    its('sha256sum') { should eq '040c1d4c506c3d650e43ed268052d04c10e6267cfde3d7911f55ab0e43e2594b' }
end

