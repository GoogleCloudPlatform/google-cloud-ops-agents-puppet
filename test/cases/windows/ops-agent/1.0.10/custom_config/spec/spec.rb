describe service('google-cloud-ops-agent') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
end

describe file("C:\\Program Files\\Google\\Cloud Operations\\Ops Agent\\config\\config.yaml") do
    it { should exist }
    its('sha256sum') { should eq '8907261f953f902a25c1c5a82365994a3de14301699ba0d3b4cc44f6490c41bc' }
end
