describe service('google-cloud-ops-agent.target') do
    it { should_not be_enabled }
    it { should_not be_running }
end