# Definition: mcollective::actionpolicy
#
# Sets up an action policy for an MCollective agent.
#
# See http://projects.puppetlabs.com/projects/mcollective-plugins/wiki/AuthorizationActionPolicy
# for informations on how action policy rules.
#
# You should declare mcollective::node before using this.
# You should also declare an mcollective::actionpolicy::base resource
# for the agent you wish to add a rule to.
#
# Parameters:
#   ['ensure']         - Whether the policy rule should be present or absent.
#   ['agent']          - The agent to which to apply the policy rule.
#   ['rpccaller']      - The rpc caller (e.g. 'cert=foo' or 'uid=1001')
#   ['auth']           - Auth rule ('allow' or 'deny').
#                        Defaults is 'allow'.
#   ['actions']        - Actions managed by this rule, separated by spaces.
#                        Defaults to '*'.
#   ['facts']          - Facts filter for which this rule applies.
#                        Defaults to '*'.
#   ['classes']        - Classes filter for which this rule applies.
#                        Defaults to '*'.
#   ['order']          - Order for concatenation.
#                        Defaults to 50.
#   ['policies_dir']   - Where the policy rules are stored.
#                        Defaults to '/etc/mcollective/policies'.
#
# Actions:
# - Deploys an MCollective Action Policy rule for an agent
#
# Sample Usage:
#   mcollective::actionpolicy { 'Allow puppetd status for cert foo':
#     ensure         => present,
#     agent          => 'puppetd',
#     rpccaller      => 'cert=foo',
#     actions        => 'status',
#   }
#
define mcollective::actionpolicy (
  $agent,
  $rpccaller,
  $auth = 'allow',
  $actions = '*',
  $facts = '*',
  $classes = '*',
  $ensure = 'present',
  $order = '50',
  $policies_dir = '/etc/mcollective/policies',
) {
  $fragment_title    = regsubst($name, '/', '_', 'G')
  concat::fragment { "mcollective.actionpolicy.${agent}.${fragment_title}":
    ensure  => $ensure,
    order   => $order,
    target  => "${policies_dir}/${agent}.policy",
    content => "${auth}\t${rpccaller}\t${actions}\t${facts}\t${classes}\n",
  }
}
