describe service('google-cloud-ops-agent') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
end

describe file('C:\Program Files\Google\cloud Operations\Ops Agent\config\config.yaml') do
    it { should exist }
end

