define mcollective::application (
  $ensure='present',
  $source=''
) {
  include ::mcollective::client

  $filesrc = $source ? {
    ''      => "puppet:///modules/mcollective/application/${name}.rb",
    default => $source,
  }

  file {"${mcollective::client::mcollective_libdir}/mcollective/application/${name}.rb":
    ensure => $ensure,
    source => $filesrc,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }
}
