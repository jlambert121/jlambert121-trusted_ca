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
# [*system*]
#   Boolean.  Whether or not the certificate should be installedi n the system keychain
#   Default: true
#
# [*java*]
#   Boolean.  Whether or not the certificate should be installedi n the java keychain
#   Default: true
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
  $system   = true,
  $java     = true,
) {

  include trusted_ca

  if ! ($content or $source) {
    crit('No content, source or symlink specified')
  }

  if $system == true {
    concat::fragment { "ca-bundle.crt-${name}":
      source  => $source,
      content => $content,
      target  => '/etc/pki/tls/certs/ca-bundle.crt',
      order   => $order,
    }
  }

  if $java == true and defined(Class['java']) {
    file { "/tmp/${name}-trustedca":
      ensure  => 'file',
      source  => $source,
      content => $content,
    }

    exec { "import ${name} to java":
      command   => "keytool -import -noprompt -trustcacerts -alias ${name} -file /tmp/${name}-trustedca -keystore /etc/alternatives/jre_1.7.0/lib/security/cacerts -storepass changeit",
      cwd       => '/tmp',
      path      => '/bin/:/usr/bin/',
      logoutput => on_failure,
      unless    => "echo '' | keytool -list -keystore /etc/alternatives/jre_1.7.0/lib/security/cacerts | grep ${name}",
      require   => File["/tmp/${name}-trustedca"],
    }
  }

}
