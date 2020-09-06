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
# [*source_base*]
#   The base path to the source. E.g. 'files' or 'modules/profile'.
#
define ssh::key
(
    Enum['present', 'absent'] $ensure,
    String                    $system_user,
    String                    $basename,
    Boolean                   $secret = true,
    Optional[String]          $source_base
)
{
    $l_source_base = $source_base ? {
        default => $source_base,
        undef   => 'files',
    }

    include ::ssh::params

    if $::kernel == 'windows' {
        $key_mode = undef
        $owner = undef
        $group = undef
    } else {
        $key_mode = $secret ? {
            true => '0600',
            false => '0644',
            default => '0600',
        }
        $owner = $system_user
        $group = $system_user
    }

    if $::kernel == 'windows' {
        $key_name = "C:\\Users\\${system_user}\\.ssh\\${basename}"
    } else {
        $key_name = $system_user ? {
            'root' => "/root/.ssh/${basename}",
            default => "${::os::params::home}/${system_user}/.ssh/${basename}",
        }
    }

    # Fool puppet-lint
    $sep = ":///"
    file { "ssh-key-${title}":
        ensure => $ensure,
        name   => $key_name,
        source => "puppet${sep}${l_source_base}/ssh-${title}",
        owner  => $owner,
        group  => $group,
        mode   => $key_mode,
    }
}
