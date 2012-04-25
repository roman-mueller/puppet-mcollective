class mcollective::rabbitmq {

  package { "rabbitmq-server": ensure => present }

  service { "rabbitmq-server":
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => Package["rabbitmq-server"],
  }

  mcollective::rabbitmq::plugin {
    ["amqp_client", "rabbitmq_stomp"]: enable => true,
  }

}
