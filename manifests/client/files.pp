# == Class: mcollective::client::files
#
# Configures an MCollective client
class mcollective::client::files {
  include ::mcollective::params

  file { '/etc/mcollective/client.cfg':
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('mcollective/client.cfg.erb'),
  }

  file { '/etc/bash_completion.d/mco':
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/mcollective/bash_completion.sh',
  }
}
