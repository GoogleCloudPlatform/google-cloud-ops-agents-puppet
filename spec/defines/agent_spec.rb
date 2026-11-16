# frozen_string_literal: true

# Copyright 2026 Google LLC
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

require 'spec_helper'

describe 'google_cloud_ops::agent' do
  let(:title) { 'ops-agent' }
  let(:facts) do
    {
      os: { 'family' => 'Debian' },
    }
  end

  context 'on Linux with default parameters for ops-agent' do
    let(:params) do
      {
        agent_type: 'ops-agent',
      }
    end

    it { is_expected.to compile.with_all_deps }

    it do
      is_expected.to contain_file('/var/cache/google-cloud-ops-agents').with(
        ensure: 'directory',
        owner: 'root',
        group: 'root',
        mode: '0700',
        force: true,
      )
    end

    it do
      is_expected.to contain_file('/var/cache/google-cloud-ops-agents/ops-agent').with(
        ensure: 'directory',
        owner: 'root',
        group: 'root',
        mode: '0700',
        force: true,
        purge: true,
        recurse: true,
      ).that_requires('File[/var/cache/google-cloud-ops-agents]')
    end

    it do
      is_expected.to contain_remote_file('/var/cache/google-cloud-ops-agents/ops-agent/add-google-cloud-ops-agent-repo.sh').with(
        ensure: 'latest',
        source: 'https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh',
        verify_peer: true,
        owner: 'root',
        group: 'root',
        mode: '0700',
      ).that_requires('File[/var/cache/google-cloud-ops-agents/ops-agent]')
    end

    it do
      is_expected.to contain_exec('install-ops-agent').with(
        command: '/var/cache/google-cloud-ops-agents/ops-agent/add-google-cloud-ops-agent-repo.sh --also-install --version=latest',
        provider: 'shell',
      ).that_requires([
        'File[/var/cache/google-cloud-ops-agents/ops-agent]',
        'Remote_file[/var/cache/google-cloud-ops-agents/ops-agent/add-google-cloud-ops-agent-repo.sh]',
      ])
    end

    it { is_expected.not_to contain_file('/tmp/ops-agent') }
  end

  context 'with unsupported agent_type' do
    let(:params) do
      {
        agent_type: 'unsupported',
      }
    end

    it { is_expected.to compile.and_raise_error(%r{parameter 'agent_type' expects a match for Enum}) }
  end
end
