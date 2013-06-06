# Fake $::concat_basedir fact
$concat_basedir = '/var/lib/puppet/concat'

# Default node to test defines
node default {
  class { '::mcollective':
    broker_host       => 'localhost',
    broker_port       => '61613',
    security_provider => 'psk',
    use_client        => true,
  }

  ::mcollective::actionpolicy::base { 'foo': }
}
