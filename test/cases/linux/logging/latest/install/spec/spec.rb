describe service('google-fluentd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
end