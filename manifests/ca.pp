# == Define: ca
#
# This define installs individual root CAs
#
#
# === Parameters
#
# [*source*]
#   String.  Path to the certificate PEM.
#   Must specify either content or source.
#   If source is specified, content is ignored.
#
# [*content*]
#   String.  Content of certificate in PEM format.
#   Must specify either content or source.
#   If source is specified, content is ignored.
#
# [*install_path*]
#   String.  Location to install trusted certificates
#
# === Examples
#
# * Installation:
#     class { 'trusted_ca': }
#
#     trusted_ca::ca { 'example.org.local':
#       source  => puppet:///data/ssl/example.com.pem
#     }
#
#     trusted_ca::ca { 'example.net.local':
#       content  => hiera("example-net-x509")
#     }
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
define trusted_ca::ca (
  $source       = undef,
  $content      = undef,
  $install_path = $::trusted_ca::install_path,
) {

  if ! defined(Class['trusted_ca']) {
    fail('You must include the trusted_ca base class before using any trusted_ca defined resources')
  }

  if $source and $content {
    fail('You must not specify both $source and $content for trusted_ca defined resources')
  }

  if $name =~ /\.crt$/ {
    $_name = $name
  } else {
    $_name = "${name}.crt"
  }


  if $source {

    validate_re($source, '\.crt$', "[Trusted_ca::Ca::${name}]: source must a PEM encoded file with the crt extension")

    file { "${install_path}/${_name}":
      ensure => 'file',
      source => $source,
      notify => Exec["validate ${install_path}/${_name}"],
      mode   => '0644',
      owner  => 'root',
      group  => 'root',
    }

  } elsif $content {

    validate_re($content, '^[A-Za-z0-9+/\n=-]+$', "[Trusted_ca::Ca::${name}]: content must a PEM encoded string")

    file { "${install_path}/${_name}":
      ensure  => 'file',
      content => $content,
      notify  => Exec["validate ${install_path}/${_name}"],
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
    }
  } else {
    fail('You must specify either $source and $content for trusted_ca defined resources')
  }

  # This makes sure the certificate is valid
  exec {"validate ${install_path}/${_name}":
    command     => "openssl x509 -in ${install_path}/${_name} -noout",
    logoutput   => on_failure,
    path        => $::trusted_ca::path,
    notify      => Exec['update_system_certs'],
    returns     => 0,
    refreshonly => true,
  }

}
