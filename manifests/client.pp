class mcollective::client (
  $broker_host,
  $broker_port,
  $security_provider,
  $broker_vhost = '/mcollective',
  $broker_user = 'guest',
  $broker_password = 'guest',
  $broker_ssl = true,
  $broker_ssl_cert = "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
  $broker_ssl_key = "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
  $broker_ssl_ca = '/var/lib/puppet/ssl/certs/ca.pem',
  $security_secret = '',
  $security_ssl_server_public = '/etc/mcollective/ssl/server-public.pem',
  $security_ssl_client_private = false,
  $security_ssl_client_public = false,
  $connector = 'rabbitmq',
  $puppetca_cadir = '/srv/puppetca/ca/',
) {

  $client_require = $::operatingsystem ? {
    /Debian|Ubuntu/ => [Package['rubygems'], Package['ruby-stomp']],
    /RedHat|CentOS/ => [Package['rubygems'], Package['rubygem-stomp']],
  }

  package { 'mcollective-client':
    ensure  => present,
    require => $client_require,
  }

  $mcollective_libdir = $::operatingsystem ? {
    /Debian|Ubuntu/ => '/usr/share/mcollective/plugins',
    /RedHat|CentOS/ => '/usr/libexec/mcollective',
  }

  file { '/etc/mcollective/client.cfg':
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('mcollective/client.cfg.erb'),
    require => Package['mcollective'],
  }

  file { '/etc/bash_completion.d/mco':
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    source  => 'puppet:///modules/mcollective/bash_completion.sh',
  }
}
