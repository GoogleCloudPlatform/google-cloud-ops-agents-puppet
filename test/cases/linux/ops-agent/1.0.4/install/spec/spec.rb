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
end