# Class trusted_ca::params
#
class trusted_ca::params {
  $certificates_version = 'latest'

  case $::osfamily {
    'RedHat': {
      $path = [ '/usr/bin', '/bin']
      $update_command = 'update-ca-trust enable && update-ca-trust'
      $install_path = '/etc/pki/ca-trust/source/anchors'

      case $::operatingsystemmajrelease {
        '6', '7': {
        }
        default: {
          fail("${::osfamily} ${::operatingsystemmajrelease} has not been tested with this module.  Please feel free to test and report the results")
        }
      }
    }
    'Debian': {
      $path = ['/bin', '/usr/bin', '/usr/sbin']
      $update_command = 'update-ca-certificates'
      $install_path = '/usr/local/share/ca-certificates'

      case $::operatingsystemrelease {
        '12.04', '14.04': {
        }
        default: {
          fail("${::osfamily} ${::operatingsystemrelease} has not been tested with this module.  Please feel free to test and report the results")
        }
      }
    }
    default: {
      fail("${::osfamily}/${::operatingsystem} ${::operatingsystemrelease} not supported")
    }
  }
}
