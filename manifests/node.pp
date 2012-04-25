class mcollective::node {

  include ruby::gems

  # Upstart requires daemonize to be set to 0
  # warning: do not name this variable $daemonize!
  $mcollective_daemonize = $operatingsystem ? {
    'Ubuntu' => 0,
    default  => 1
  }

  case $::operatingsystem {

    /Debian|Ubuntu/: {

      package { "libstomp-ruby":
        ensure => absent,
      }
      package { "ruby-stomp":
        ensure  => present,
        require => Package["libstomp-ruby"],
        notify  => Service["mcollective"],
      }

      package { "mcollective":
        ensure  => present,
        require => [Package["rubygems"], Package["ruby-stomp"]],
      }

      $mcollective_libdir = '/usr/share/mcollective/plugins'
    }

    /RedHat|CentOS/: {
      package { ['rubygem-net-ping', 'rubygem-stomp']:
        ensure => present,
        notify => Service['mcollective'],
      }

      package { "mcollective":
        ensure  => present,
        require => [Package['rubygem-stomp'], Package['rubygem-net-ping']],
      }

      $mcollective_libdir = '/usr/libexec/mcollective'
    }

    default: {
      fail("Unsupported operating system: ${::operatingsystem}")
    }

  }

  service { "mcollective":
    ensure    => running,
    hasstatus => true,
    enable    => true,
    require   => Package["mcollective"],
  }

  file { "/etc/mcollective/server.cfg":
    mode    => 0640,
    owner   => "root",
    group   => "root",
    content => template("mcollective/server.cfg.erb"),
    notify  => Service["mcollective"],
    require => Package["mcollective"],
  }

  file { "/etc/mcollective/facts.yaml":
    owner    => "root",
    group    => "root",
    mode     => 400,
    loglevel => debug,  # this is needed to avoid it being logged and reported on every run
    # avoid including highly-dynamic facts as they will cause unnecessary template writes
    content  => inline_template("<%= scope.to_hash.reject { |k,v| k.to_s =~ /(uptime|timestamp|free)/ }.to_yaml %>"),
    require  => Package["mcollective"],
  }

}
