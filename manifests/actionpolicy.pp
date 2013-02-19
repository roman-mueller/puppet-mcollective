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
