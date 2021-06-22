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
    its('sha256sum') { should eq '1bd5261e75092fb6e76feee034a3cf0cf8e3fa981cdc819c709be945f8ff4bb9' }
end

describe file('/etc/google-fluentd/plugin/plugin.rb') do
    it { should exist }
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
    its('sha256sum') { should eq 'b74d2d88969a4664132555d5d030e08f72f2e135f6005edbfe4b3aec84a42412' }
end

