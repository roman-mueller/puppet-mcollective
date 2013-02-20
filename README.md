# MCollective Puppet Module

This module manages MCollective.

It supports:
* generic STOMP and RabbitMQ connectors (optionally over SSL)
* PSK and SSL security providers
* Action policy rules

## Classes

This module provides two classes to configure MCollective nodes and clients.

### mcollective::node

Installs and configures an MCollective node:

    class { '::mcollective::node':
      broker_host       => 'rabbitmq.example.com',
      broker_port       => '61614',
      security_provider => 'psk',
      security_secret   => 'P@S5w0rD',
    }

    class { '::mcollective::node':
      broker_host                 => 'rabbitmq.example.com',
      broker_port                 => '61614',
      security_provider           => 'ssl',
    }

### mcollective::client

Installs and configures an MCollective client:

    class { '::mcollective::client':
      broker_host       => 'rabbitmq.example.com',
      broker_port       => '61614',
      security_provider => 'psk',
      security_secret   => 'P@S5w0rD',
    }
 
    class { '::mcollective::client':
      broker_host                 => 'rabbitmq.example.com',
      broker_port                 => '61614',
      security_provider           => 'ssl',
    }

## Definitions

Several definitions allow to enhance MCollective nodes and clients.

### mcollective::plugin

Installs an MCollective plugin using packages:

    mcollective::plugin { 'puppetca':
      ensure         => present,
    }

### mcollective::application

Installs an MCollective application from a file:

    mcollective::application { 'healthcheck':
      ensure         => present,
    }

### mcollective::client::certificate

Deploys a public client SSL certificate for authentication:

    mcollective::client::certificate { 'foo':
      ensure  => present,
      key_source_dir => 'puppet:///module_name/path/to/dir/',
    }

### mcollective::actionpolicy::base

Sets up an base action policy file for an agent:

    mcollective::actionpolicy::base { 'puppetd':
      ensure => present,
    }

### mcollective::actionpolicy

Sets up an action policy rule for an agent:

    mcollective::actionpolicy { 'Allow puppetd status for cert foo':
      ensure         => present,
      agent          => 'puppetd',
      rpccaller      => 'cert=foo',
      actions        => 'status',
    }





