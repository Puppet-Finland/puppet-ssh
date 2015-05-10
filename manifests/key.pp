#
# == Define: ssh::key
#
# Setup public and private SSH keys for a user
#
# == Parameters
#
# [*title*]
#   Basename of the key on the Puppet fileserver. Prepend the filename with 
#   'ssh-' to get the effective filename, for example 'ssh-ec2.pem' or 
#   'ssh-john-id_dsa'.
# [*system_user*]
#   The system user to install this key for. For example 'john'.
# [*basename*]
#   Basename of the key on the target system. For example 'id_dsa.pub'.
# [*secret*]
#   Whether this key should be private (mode => '0600') or public (mode => 
#   '0644'). Valid values are true (default) and false.
#
define ssh::key
(
    $ensure,
    $system_user,
    $basename,
    $secret = true
)
{
    include ::ssh::params

    $key_mode = $secret ? {
        true => '0600',
        false => '0644',
        default => '0600',
    }

    $basedir = $system_user ? {
        'root' => '/root/.ssh',
        default => "${::os::params::home}/${system_user}/.ssh",
    }

    file { "ssh-key-${title}":
        ensure => $ensure,
        name   => "${basedir}/${basename}",
        source => "puppet:///files/ssh-${title}",
        owner  => $system_user,
        group  => $system_user,
        mode   => $key_mode,
    }
}
