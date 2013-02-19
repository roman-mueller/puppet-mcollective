# Definition: mcollective::client::certificate
#
# This definition provides a way to manage SSL client certificates
# for MCollective.
#
# See http://docs.puppetlabs.com/mcollective/reference/plugins/security_ssl.html
# for informations on how to create certificates.
#
# You should declare mcollective::node before using this.
#
# Parameters:
#   ['ensure']         - Whether the certificate should be present or absent.
#   ['key_source']     - The source for the key file.
#   ['key_source_dir'] - The directory where key files are stored.
#                        If specified, overrides 'key_source'
#                        with ${key_dir}/${name}.pem
#   ['cert_dir']       - Where to deploy the certificates.
#
# Actions:
# - Deploys an MCollective SSL certificate
#
# Sample Usage:
#   mcollective::client::certificate { 'foo':
#     ensure  => present,
#     key_source_dir => 'puppet:///module_name/path/to/dir/',
#   }
#
define mcollective::client::certificate (
  $key_source = undef,
  $key_source_dir = undef,
  $ensure = 'present',
  $cert_dir = '/etc/mcollective/ssl/clients',
) {
  if (!$key_source and !$key_source_dir) {
    fail('You must pass either $key_source or $key_source_dir')
  }

  $_key_source = $key_source_dir ? {
    undef   => $key_source,
    default => "${key_source_dir}/${name}.pem",
  }

  file {
    "${cert_dir}/${name}.pem":
      ensure => $ensure,
      owner  => 'root',
      group  => 'root',
      mode   => '0640',
      source => $_key_source,
  }
}
