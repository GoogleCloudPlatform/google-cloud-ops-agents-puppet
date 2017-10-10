# Google Stackdriver Logging Puppet Module

## Overview

This module will install the Google Stackdriver Logging Agent. This application
is required for using Stackdriver Monitoring with a VM.

The Monitoring agent is a collectd-based daemon that gathers system and
application metrics from virtual machine instances and sends them to
Stackdriver Monitoring. By default, the Monitoring agent collects disk, CPU,
network, and process metrics.

## Setup

To install this module on your Puppet Master (or Puppet Client/Agent), use the
Puppet module installer:

    puppet module install google-glogging

Optionally you can install support to _all_ Google Cloud Platform products at
once by installing our "bundle" [`google-cloud`][bundle-forge] module:

    puppet module install google-cloud

## Usage

To install the [Google Stackdriver Logging Agent][logging-agent], add the
following class to your Puppet manifest.

```puppet
include glogging::agent
```

## Permissions Required

Each GCP machine requires the `https://www.googleapis.com/auth/logging.write`
scope in order to write logs.

Using the [gcompute_instance][] resource, you can add the following:

```puppet
gcompute_instance { 'my-vm':
  ...
  service_accounts   => {
    ...
    scopes => [
        ...
        # Enable Stackdriver Logging API access
        'https://www.googleapis.com/auth/logging.write',
        ...
    ],
  }
}
```

For more information on how to use the `gcompute_instance` please visit the
[google-gcompute][] module documentation.


## Viewing Logs

Please go to the [Google Cloud console][logs] to view the Stackdriver logs.


[logging-agent]: https://cloud.google.com/logging/docs/agent/
[google-gcompute]: https://github.com/GoogleCloudPlatform/puppet-google-compute
[gcompute_instance]: https://github.com/GoogleCloudPlatform/puppet-google-compute#gcompute_instance
[logs]: https://console.cloud.google.com/logs
