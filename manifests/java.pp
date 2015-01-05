# == Define: java
#
# This define installs certs to a java cacerts file
#
#
# === Parameters
#
# [*source*]
#   String.  Path to the certificate PEM.
#
# [*java_keystore*]
#   String.  Location of java cacerts file
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
define trusted_ca::java (
  $source,
  $java_keystore,
) {

  file { "/tmp/${name}-trustedca":
    source  => $source,
  }

  exec { "import ${name} to java":
    command   => "keytool -import -noprompt -trustcacerts -alias ${name} -file /tmp/${name}-trustedca -keystore ${java_keystore} -storepass changeit",
    cwd       => '/tmp',
    path      => '/bin/:/usr/bin/',
    logoutput => on_failure,
    unless    => "echo '' | keytool -list -keystore ${java_keystore} | grep ${name}",
    require   => File["/tmp/${name}-trustedca"],
  }

}