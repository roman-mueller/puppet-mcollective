# == Class: mcollective::node::service
#
# Manages an MCollective node service
class mcollective::node::service {
  service { 'mcollective':
    ensure    => running,
    hasstatus => true,
    enable    => true,
  }
}
