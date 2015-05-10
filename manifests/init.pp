# == Class: ssh
#
# This class sets up OpenSSH client and optionally configures it for users.
#
# == Parameters
#
# [*manage*]
#   Whether to manage OpenSSH client using Puppet. Valid values are 'yes' 
#   (default) and 'no'.
# [*ensure*]
#   Status of OpenSSH client. Valid values 'present' (default) and 'absent'.
# [*userconfigs*]
#   A hash of ssh::userconfigs resources to realize.
#
# == Examples
#
# A Hiera example:
#
#   ---
#   classes:
#       - ssh
#
#   ssh::userconfigs:
#       john:
#           keys:
#               john-id_dsa:
#                   basename: 'id_dsa'
#               john-id_dsa.pub:
#                   basename: 'id_dsa.pub'
#                   secret: false
#               ec2.pem:
#                   basename: 'ec2.pem'
#
# The SSH key files should be placed on the Puppet fileserver and named as
# ssh-${title}. In the above case this would translate to
#
#   ssh-john-id_dsa
#   ssh-john-id_dsa.pub
#   ssh-ec2.pem
#
# The forced file prefix is there to lessen the chance of filename clashes with 
# other modules.
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
    $manage = 'yes',
    $ensure = 'present',
    $userconfigs = {}

) inherits ssh::params
{

if $manage == 'yes' {

    class { '::ssh::install':
        ensure => $ensure,
    }

    create_resources('ssh::userconfig', $userconfigs)
}
}
