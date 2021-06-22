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
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
    its('sha256sum') { should eq '202256588869d4efc115317829c0435cdd8caf2e876f259509d552e974b4f907' }
end

