# Definition: mcollective::actionpolicy::base
#
# Sets up a base action policy for an MCollective agent.
#
# See http://projects.puppetlabs.com/projects/mcollective-plugins/wiki/AuthorizationActionPolicy
# for informations on how action policy rules.
#
# You should declare mcollective::node before using this.
#
# Parameters:
#   ['ensure']         - Whether the policy rule should be present or absent.
#   ['default_policy'] - The default policy to apply.
#                        Defaults to 'deny'.
#
# Actions:
# - Deploys a base MCollective Action Policy rule for an agent
#
# Sample Usage:
#   mcollective::actionpolicy::base { 'puppetd':
#     ensure => present,
#   }
#
define mcollective::actionpolicy::base (
  $ensure = 'present',
  $default_policy = 'deny',
) {
  if defined(Class['mcollective::node']) {
    $policies_dir = $mcollective::node::policies_dir
  } else {
    fail('You must declare the mcollective::node class before you can use mcollective::actionpolicy::base')
  }

  include concat::setup

  concat { "${policies_dir}/${name}.policy":
    owner => 'root',
    group => 'root',
    mode  => '0640',
  }

  concat::fragment { "mcollective.actionpolicy.${name}.base":
    ensure  => $ensure,
    order   => '00',
    target  => "${policies_dir}/${name}.policy",
    content => "policy default ${default_policy}\n",
  }
}
