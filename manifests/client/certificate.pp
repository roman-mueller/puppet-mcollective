define mcollective::client::certificate (
  $key_source,
  $ensure = 'present',
  $cert_dir = '/etc/mcollective/ssl/clients',
) {
  file {
    "${cert_dir}/${name}.pem":
      ensure => $ensure,
      owner  => 'root',
      group  => 'root',
      mode   => '0640',
      source => $key_source,
  }
}
