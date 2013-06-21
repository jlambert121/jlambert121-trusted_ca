# == Class: trusted_ca
#
# This class installs additional trusted root CAs
#
#
# === Parameters
#
# [*version*]
#   String.  What version of ca-certificates to install (the package that
#     owns the certificate bundle).
#   Default: 2010.63-3.el6_1_5
#
# [*ca_base*]
#   String.  Path to the base ca-bundle.crt
#   Default: crt included with the module
#
#
# === Examples
#
# * Installation:
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
class trusted_ca (
  $version = '2010.63-3.el6_1.5',
  $ca_base = 'puppet:///modules/trusted_ca/ca-bundle.crt',
) {

  package { 'ca-certificates':
    ensure  => $version
  }

  concat {
    '/etc/pki/tls/certs/ca-bundle.crt':
      owner   => root,
      group   => root,
      mode    => '0444',
  }

  concat::fragment {
    'ca-bundle.crt-base':
      source  => $ca_base,
      target  => '/etc/pki/tls/certs/ca-bundle.crt',
      order   => 01,
  }

}


