cloud_ops::agent {'logging':
  agent_type            => 'logging',
  main_config           => '/tmp/cases/linux/logging/latest/custom_config/files/google-fluentd.conf',
  additional_config_dir => '/tmp/cases/linux/logging/latest/custom_config/files/plugins'
}
