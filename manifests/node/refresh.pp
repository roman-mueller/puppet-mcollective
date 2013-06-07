# == Class: mcollective::node::refresh
#
# Refresh MCollective (for new plugins)
class mcollective::node::refresh {
  exec { 'reload mcollective':
    command     => 'pkill -USR1 -f "ruby.*mcollectived"',
    refreshonly => true,
  }
}
