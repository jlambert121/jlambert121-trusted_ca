# == Class: trusted_ca
#
# This class installs additional trusted root CAs
#
#
# === Parameters
#
# None
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
class trusted_ca {

  package { 'ca-certificates':
    ensure  => latest
  }

}
