# Installs the Google Cloud Logging Agent to a RedHat based machine.
#
# Derived from Logging Agent's installation script:
#   https://dl.google.com/cloudagents/install-logging-agent.sh
#
# For more details please visit:
#   https://cloud.google.com/logging/docs/agent/installation
class glogging::agent::redhat(
  $credential_file = undef,
) {

  $os_major = $::facts['os']['release']['major']
  $repo_name = "google-cloud-logging-el${os_major}-\$basearch"
  $cloud_yum_repo = 'https://packages.cloud.google.com/yum/repos'

  $optional_credential_file = $credential_file ? {
    undef   => undef,
    default => File[$credential_file],
  }

  yumrepo { 'google_cloud_logging':
    ensure        => 'present',
    name          => 'google-cloud-logging',
    descr         => 'Google Cloud Logging Agent Repository',
    baseurl       => "${cloud_yum_repo}/${repo_name}",
    enabled       => 1,
    gpgcheck      => 1,
    repo_gpgcheck => 1,
    gpgkey        => [
      'https://packages.cloud.google.com/yum/doc/yum-key.gpg',
      'https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg',
    ],
  }

  package { 'google-fluentd':
    ensure  => installed,
    require => Yumrepo['google_cloud_logging'],
  }

  package { 'google-fluentd-catch-all-config':
    ensure  => installed,
    require => Yumrepo['google_cloud_logging'],
  }

  service { 'google-fluentd':
    ensure  => running,
    require => [
      Package['google-fluentd'],
      Package['google-fluentd-catch-all-config'],
      $optional_credential_file,
    ],
  }

}
