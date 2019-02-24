
# centreon_register

[![Build Status](https://travis-ci.org/hdep/puppet-centreon_register.svg?branch=master)](https://travis-ci.org/hdep/puppet-centreon_register)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with centreon_register](#setup)
    * [What centreon_register affects](#what-centreon_register-affects)
    * [Beginning with centreon_register](#beginning-with-centreon_register)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This module permit to register a host to centreon (https://www.centreon.com) server by using REST API.
The main idea is when a I deploy a new host with puppet, I want to automatically add this host to monitoring with a host template of your choice.

## Setup

### What centreon_register affects **OPTIONAL**

This module deploy a bash script into /tmp by default, and install curl if not present.
This script use curl in order to modify centreon server configuration.

The host need access to the Centreon server via http or https.

### Beginning with centreon_register

Simply declare the class like this and specify mandatory option to reach centreon server :

```
class centreon_register {
  centreon_webapi_host    => 'http://centreon.domain.fr',
  centreon_login          => 'admin',
  centreon_admin_password => 'password'
}
```

## Usage




## Limitations

Currently the script centreon_register.sh car only create a host with some parameters : hostname, alias, IP, host template, Poller, One custom macro.
Has been tested with Debian 9 and Redhat 7. Should be working on any OS with curl.

## Development

PR are welcome !

TO DO :

* Support windows OS
* Add more option to centreon_register.sh

## Release Notes/Contributors/Etc. **Optional**

Module inspired by  https://github.com/centreon/centreon-iac-puppet-configurator
