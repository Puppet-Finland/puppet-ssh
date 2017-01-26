# == Class: ssh
#
# This class sets up OpenSSH client and optionally configures it for users.
#
# == Parameters
#
# [*manage*]
#   Whether to manage OpenSSH client using Puppet. Valid values are true
#   (default) and false.
# [*ensure*]
#   Status of OpenSSH client. Valid values 'present' (default) and 'absent'.
# [*userconfigs*]
#   A hash of ssh::userconfigs resources to realize.
#
# == Authors
#
# Samuli Seppänen <samuli.seppanen@gmail.com>
#
# == License
#
# BSD-license. See file LICENSE for details.
#
class ssh
(
    Boolean $manage = true,
            $ensure = 'present',
    Hash    $userconfigs = {}

) inherits ssh::params
{

if $manage {

    unless $::osfamily == 'windows' {
        class { '::ssh::install':
            ensure => $ensure,
        }
    }

    create_resources('ssh::userconfig', $userconfigs)
}
}
