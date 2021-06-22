describe service('google-cloud-ops-agent.target') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
end

describe package('google-cloud-ops-agent') do
    it { should be_installed }
    # This code will break, if 2.x.x is ever released
    its('version') { should match /1./ }
end

describe file('/etc/google-cloud-ops-agent/config.yaml') do
    it { should exist }
end