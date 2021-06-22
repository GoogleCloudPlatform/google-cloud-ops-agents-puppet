describe service('stackdriver-agent') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
end

describe file('/etc/stackdriver/collectd.conf') do
    it { should exist }
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
    its('sha256sum') { should eq 'ff1857537ddfa60e5774cf7594f1a773211350ce35ce02917ab289bd1b316076' }
end

describe file('/etc/stackdriver/collectd.d/example_plugin.conf') do
    it { should exist }
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
    its('sha256sum') { should eq '5f36a2ef4c44dc7589d25ce50addc8c3342359ec707aa9ce9d2d2f60be947d60' }
end

