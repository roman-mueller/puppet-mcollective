class mcollective::params {
  $broker_vhost = '/mcollective'
  $broker_user = 'guest'
  $broker_password = 'guest'
  $broker_ssl = true
  $broker_ssl_cert = '/etc/mcollective/ssl/mco-client.crt'
  $broker_ssl_key = '/etc/mcollective/ssl/mco-client.key'
  $broker_ssl_ca = '/etc/mcollective/ssl/ca.pem'
  $security_secret = ''
  $security_ssl_server_private = '/etc/mcollective/ssl/server-private.pem'
  $security_ssl_server_public = '/etc/mcollective/ssl/server-public.pem'
  $security_ssl_client_private = false
  $security_ssl_client_public = false
  $security_aes_server_private = '/etc/mcollective/ssl/server-private.pem'
  $security_aes_server_public = '/etc/mcollective/ssl/server-public.pem'
  $security_aes_client_private = false
  $security_aes_client_public = false
  $security_aes_send_pubkey = 0
  $security_aes_learn_pubkeys = 0
  $security_aes_enforce_ttl = 1
  $connector = 'rabbitmq'
  $puppetca_cadir = '/srv/puppetca/ca/'
  $rpcauthorization = false
  $rpcauthprovider = 'action_policy'
  $rpcauth_allow_unconfigured = 0
  $rpcauth_enable_default = 1
  $cert_dir = '/etc/mcollective/ssl/clients'
  $policies_dir = '/etc/mcollective/policies'
  $use_node = true
  $use_client = false
  $direct_addressing = 0
  $registration = 'Agentlist'
  $registerinterval = 300

  case $::osfamily {
    'Debian': {
      $client_require = Package['rubygems', 'ruby-stomp']
      $server_require = Package['rubygems', 'ruby-stomp']
      $plugin_require = Package['rubygems', 'ruby-stomp']
      $libdir = '/usr/share/mcollective/plugins'
    }

    'RedHat': {
      $client_require = Package['rubygems', 'rubygem-stomp']
      $server_require = Package['rubygems', 'rubygem-stomp', 'rubygem-net-ping']
      $plugin_require = Package['rubygems', 'rubygem-stomp']
      $libdir = '/usr/libexec/mcollective'
    }

    default: {
      fail("Unsupported OS family ${::osfamily}")
    }
  }
}
