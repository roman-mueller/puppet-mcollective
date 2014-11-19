# == Class: mcollective::node::packages
#
# Installs an MCollective node
#
class mcollective::node::packages {
  include ::mcollective::params

  case $::osfamily {

    'Debian': {

      package { 'libstomp-ruby':
        ensure => absent,
      }
      package { 'ruby-stomp':
        ensure  => present,
        require => Package['libstomp-ruby'],
        notify  => Service['mcollective'],
      }

      augeas { 'Enable mcollective':
        lens    => 'Shellvars.lns',
        incl    => '/etc/default/mcollective',
        changes => 'set RUN yes',
        require => Package['mcollective'],
        notify  => Service['mcollective'],
      }

    }

    'RedHat': {
      if $::operatingsystemmajrelease != '7' {
        package { ['rubygem-net-ping']:
          ensure => present,
          notify => Service['mcollective'],
        }
      }
      package { ['rubygem-stomp']:
        ensure => present,
        notify => Service['mcollective'],
      }

    }

    default: {
      fail("Unsupported OS family: ${::osfamily}")
    }

  }

  package { 'mcollective':
    ensure  => present,
    require => $mcollective::params::server_require,
  }
}
