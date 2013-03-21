# simple_* and wrong_os tests
node default {
  class { '::mcollective':
    broker_host       => 'localhost',
    broker_port       => '61613',
    security_provider => 'psk',
  }
}
