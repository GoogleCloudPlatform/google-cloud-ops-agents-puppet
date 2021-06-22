cloud_ops::agent {'ops-agent':
  agent_type  => 'ops-agent',
  version     =>  '1.0.4',
  main_config => '/tmp/cases/linux/ops-agent/1.0.4/custom_config/config.yaml'
}
