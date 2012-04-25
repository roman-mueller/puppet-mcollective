define mcollective::plugin (
  $ensure='present'
) {

  $package = $::operatingsystem ? {
    /Debian|Ubuntu/ => "mcollective-agent-${name}",
    /RedHat|CentOS/ => "mcollective-plugins-${name}",
  }

  package { $package:
    ensure => $ensure,
#    notify => Service['mcollective'],
  }
}
