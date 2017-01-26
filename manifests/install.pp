# == Class: ssh::install
#
# This class installs ssh
#
class ssh::install
(
    Enum['present','absent'] $ensure

) inherits ssh::params
{
    package { $::ssh::params::package_name:
        ensure => $ensure,
    }
}
