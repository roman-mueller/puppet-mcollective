# == Class: mcollective::node::service
#
# Manages an MCollective node service
class mcollective::node::service {
  service { 'mcollective':
    ensure    => running,
    hasstatus => true,
    enable    => true,
  }

  exec { 'reload mcollective':
    command     => 'pkill -USR1 -f "ruby.*mcollectived"',
    refreshonly => true,
  }
}
