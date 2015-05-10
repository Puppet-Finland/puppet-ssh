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
        default: {
            fail("Unsupported OS: ${::osfamily}")
        }
    }
}
