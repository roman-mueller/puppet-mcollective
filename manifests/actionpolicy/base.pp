define mcollective::actionpolicy::base (
  $ensure = 'present',
  $policies_dir = '/etc/mcollective/policies',
  $default_policy = 'deny',
) {
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
