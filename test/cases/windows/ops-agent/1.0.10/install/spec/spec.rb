describe service('google-cloud-ops-agent') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
end

describe file('C:\Program Files\Google\cloud Operations\Ops Agent\config\config.yaml') do
    it { should exist }
    its('sha256sum') { should eq '62067d867f435a95e47e2bbeb19c3276e39da064400536304d8347945a04c4ee' }
end