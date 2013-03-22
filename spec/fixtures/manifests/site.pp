# Default node to test defines
node default {
  class { '::mcollective':
    broker_host       => 'localhost',
    broker_port       => '61613',
    security_provider => 'psk',
  }

  ::mcollective::actionpolicy::base { 'foo': }
}
