cloud_ops::agent {'ops-agent':
  agent_type  => 'ops-agent',
  version     =>  '1.0.10@1',
  main_config => 'C:\ci\puppet\modules\cloud_ops\test\cases\windows\ops-agent\1.0.10\custom_config\config.yaml'
}
