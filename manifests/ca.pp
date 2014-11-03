# == Define: ca
#
# This define installs individual root CAs
#
#
# === Parameters
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
# [*java_keystore*]
#   String.  Path to the java keystore file.
#   Default: /etc/alternatives/jre_1.7.0/lib/security/cacerts
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
  $source        = undef,
  $order         = 99,
  $system        = true,
  $java          = true,
  $java_keystore = '/etc/alternatives/jre_1.7.0/lib/security/cacerts',
) {

  include trusted_ca

  file { "/tmp/${name}-trustedca":
    source  => $source,
  }

  if $system == true {
    exec { "import ${name} to ca-bundle.crt":
      command   => "openssl x509 -in /tmp/${name}-trustedca -text >> /etc/pki/tls/certs/ca-bundle.crt",
      path      => '/bin/:/usr/bin/',
      logoutput => on_failure,
      onlyif    => "openssl verify /tmp/${name}-trustedca | grep error",
      require   => File["/tmp/${name}-trustedca"],
    }
  }

  if $java == true and defined(Class['java']) {
    exec { "import ${name} to java":
      command   => "keytool -import -noprompt -trustcacerts -alias ${name} -file /tmp/${name}-trustedca -keystore ${java_keystore} -storepass changeit",
      cwd       => '/tmp',
      path      => '/bin/:/usr/bin/',
      logoutput => on_failure,
      unless    => "echo '' | keytool -list -keystore ${java_keystore} | grep ${name}",
      require   => File["/tmp/${name}-trustedca"],
    }
  }

}
