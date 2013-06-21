# == Define: ca
#
# This define installs individual root CAs
#
#
# === Parameters
#
# [*content*]
#   String.  Certificate PEM.
#   Default: undef
#
# [*source*]
#   String.  Path to the certificate PEM.
#   Default: undef
#
# [*order*]
#   Integer.  Order of certificate ordering.
#   Default: 99
#
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
#
# === Copyright
#
# Copyright 2013 EvenUp.
#
define trusted_ca::ca (
  $content  = undef,
  $source   = undef,
  $order    = 99,
) {

  include trusted_ca

  if ! ($content or $source) {
    crit('No content, source or symlink specified')
  }

  concat::fragment {
    "ca-bundle.crt-${name}":
      source  => $source,
      content => $content,
      target  => '/etc/pki/tls/certs/ca-bundle.crt',
      order   => $order,
  }

}
