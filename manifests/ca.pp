# == Define: ca
#
# This define installs individual root CAs
#
#
# === Parameters
#
# [*source*]
#   String.  Path to the certificate PEM.
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
#
# === Authors
#
# * Justin Lambert <mailto:jlambert@letsevenup.com>
#
define trusted_ca::ca (
  $source,
  $install_path = $::trusted_ca::install_path,
) {

  if ! defined(Class['trusted_ca']) {
    fail('You must include the trusted_ca base class before using any trusted_ca defined resources')
  }

  validate_re($source, '\.crt$', "[Trusted_ca::Ca::${name}]: source must a PEM encded file with the crt extension")

  if $name =~ /\.crt$/ {
    $_name = $name
  } else {
    $_name = "${name}.crt"
  }

  file { "${install_path}/${_name}":
    source => $source,
    notify => Exec['update_system_certs'],
  }

}
