# Google Stackdriver Logging Puppet Module

## Overview

This module will install the Google Stackdriver Logging Agent. This application
is required for using Stackdriver Monitoring with a VM.

The Monitoring agent is a collectd-based daemon that gathers system and
application metrics from virtual machine instances and sends them to
Stackdriver Monitoring. By default, the Monitoring agent collects disk, CPU,
network, and process metrics.

## Permissions Required

Each GCP machine requires the `https://www.googleapis.com/auth/logging.write`
scope in order to write logs.

Using the gcompute_instance resource, you can add the following:

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

## Puppet Manifest

To use, add the following class to your Puppet manifest.

    include glogging::agent

## Viewing Logs

Please go to the [Google Cloud console][logs] to view the Stackdriver logs.


[logs]: https://console.cloud.google.com/logs
