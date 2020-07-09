# Installs the Google Cloud Logging Agent to a Debian`based machine.
#
# Derived from Logging Agent's installation script:
#   https://dl.google.com/cloudagents/install-logging-agent.sh
#
# For more details please visit:
#   https://cloud.google.com/logging/docs/agent/installation
class glogging::agent::debian(
  $credential_file = undef,
) {

  $os_codename = $::facts['os']['distro']['codename']

  $repo_host = 'packages.cloud.google.com'
  $repo_name = 'google-cloud-logging-wheezy'

  $optional_credential_file = $credential_file ? {
    undef   => undef,
    default => File[$credential_file],
  }

  apt::source { 'google-cloud-logging':
    comment  => 'Google Cloud Logging repository',
    location => "http://${repo_host}/apt",
    release  => $repo_name,
    repos    => 'main',
    key      => {
      'id'     => '54A647F9048D5688D7DA2ABE6A030B21BA07F4FB',
      'server' => 'pgp.mit.edu',
    },
    include  => {
      'deb' => true,
    },
  }

  package { 'google-fluentd':
    ensure  => installed,
    require => Apt::Source['google-cloud-logging'],
    notify  => Service['google-fluentd'],
  }

  package { 'google-fluentd-catch-all-config':
    ensure  => installed,
    require => Apt::Source['google-cloud-logging'],
    notify  => Service['google-fluentd'],
  }

  service { 'google-fluentd':
    ensure     => running,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      Package['google-fluentd'],
      Package['google-fluentd-catch-all-config'],
      $optional_credential_file,
    ],
  }

}
