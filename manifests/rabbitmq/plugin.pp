define mcollective::rabbitmq::plugin($enable=true) {

  case $enable {

    true: {
      exec { "enable rabbitmq plugin $name":
        command => "rabbitmq-plugins enable $name",
        unless  => "rabbitmq-plugins list -E -m | egrep '^$name$' > /dev/null",
        notify  => Service["rabbitmq-server"],
        require => Package["rabbitmq-server"],
      }
    }

    false: {
      exec { "disable rabbitmq plugin $name":
        command => "rabbitmq-plugins disable $name",
        onlyif  => "rabbitmq-plugins list -E -m | egrep '^$name$' > /dev/null",
        notify  => Service["rabbitmq-server"],
        require => Package["rabbitmq-server"],
      }
    }
  }

}

