# Installs the Google Cloud Logging Agent to the machine.
#
# For more details please visit:
#   https://cloud.google.com/logging/docs/agent/installation
class glogging::agent(
  $credential_file = undef,
) {

  case $::facts['os']['family'] {
    /RedHat/: { # RHEL, CentOS
      class { 'glogging::agent::redhat':
        credential_file => $credential_file,
      }
    }

    /Debian/: { # Debian, Ubuntu
      class { 'glogging::agent::debian':
        credential_file => $credential_file,
      }
    }

    /windows/: {
      include glogging::agent::windows
    }

    default: {
      fail("Unsupported operating system: ${::operatingsystem}")
    }
  }

}
