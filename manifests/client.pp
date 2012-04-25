class mcollective::client {

  package { "mcollective-client":
    ensure  => present,
    require => [Package["rubygems"], Package["ruby-stomp"]],
  }

  file { "/etc/mcollective/client.cfg":
    mode    => 0644,
    owner   => "root",
    group   => "root",
    content => template("mcollective/client.cfg.erb"),
    require => Package["mcollective"],
  }
}
