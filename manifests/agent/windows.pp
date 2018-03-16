# Installs the Google Cloud Logging Agent to a Windows machine.
#
# For more details please visit:
#   https://cloud.google.com/logging/docs/agent/installation
class glogging::agent::windows(
  $version = 46,
) {

  $repo = 'https://repo.stackdriver.com/windows'
  $installer = "StackdriverMonitoring-GCM-${version}.exe"
  $download_url = "${repo}/${installer}"

  $install_dir = 'C:\Program Files (x86)\Stackdriver\MonitoringAgent'
  $uninstall_app = "${install_dir}\\uninstall.exe"

  $install_app = "C:\\Windows\\TEMP\\${installer}"

  exec { 'download-stackdriver-agent':
    command  =>
      "Invoke-WebRequest -Uri '${download_url}' -OutFile '${install_app}'",
    provider => powershell,
    creates  => $install_app,
  }

  package { 'stackdriver-logging-agent':
    ensure          => installed,
    name            => "Google Stackdriver Monitoring Agent GCM-${version}",
    source          => $install_app,
    install_options => [ '/S' ],
    require         => Exec['download-stackdriver-agent'],
  }

  service { 'StackdriverMonitoring':
    ensure  => running,
    enable  => true,
    require => Package['stackdriver-logging-agent'],
  }

}

