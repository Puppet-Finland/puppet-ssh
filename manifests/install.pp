# == Class: ssh::install
#
# This class installs ssh
#
class ssh::install
(
    $ensure

) inherits ssh::params
{
    package { $::ssh::params::package_name:
        ensure => $ensure,
    }
}
