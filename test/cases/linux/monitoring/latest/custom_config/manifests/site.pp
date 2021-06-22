cloud_ops::agent {'monitoring':
  agent_type            => 'monitoring',
  main_config           => '/tmp/cases/linux/monitoring/latest/custom_config/files/collectd.conf',
  additional_config_dir => '/tmp/cases/linux/monitoring/latest/custom_config/files/plugins'
}
