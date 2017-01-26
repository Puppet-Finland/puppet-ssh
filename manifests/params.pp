#
# == Class: ssh::params
#
# Defines some variables based on the operating system
#
class ssh::params {

    include ::os::params

    case $::osfamily {
        'RedHat': {
            $package_name = 'openssh-clients'
        }
        'Debian': {
            $package_name = 'openssh-client'
        }
        'windows': {
            # Nothing here at the moment, but we don't want the module to fail on Windows
        }
        default: {
            fail("Unsupported OS: ${::osfamily}")
        }
    }
}
