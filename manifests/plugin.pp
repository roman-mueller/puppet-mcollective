# Definition: mcollective::plugin
#
# Sets up an MCollective plugin using packages.
#
# Parameters:
#   ['ensure']         - Whether the plugin should be present or absent.
#
# Actions:
# - Installs an MCollective plugin using packages.
#
# Sample Usage:
#   mcollective::plugin { 'puppetca':
#     ensure         => present,
#   }
#
define mcollective::plugin (
  $ensure='present'
) {

  include ::mcollective::params

  $package = $::osfamily ? {
    'Debian' => "mcollective-agent-${name}",
    'RedHat' => "mcollective-plugins-${name}",
  }

  package { $package:
    ensure  => $ensure,
    require => $mcollective::params::plugin_require,
    notify  => Exec['reload mcollective'],
  }
}
