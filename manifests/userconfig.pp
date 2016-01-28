# == Define: ssh::userconfig
#
# Configure SSH for a system user
#
# == Parameters
#
# [*system_user*]
#   The system user to configure SSH for. Defaults to resource $title.
# [*ensure*]
#   Whether this user's configurations should be 'present' (default) or 'absent'
# [*keys*]
#   Hash of ssh:key resources to realize.
#
define ssh::userconfig
(
    $system_user = $title,
    $ensure = 'present',
    $keys = {}
)
{
    include ::ssh::params

    $basedir = $system_user ? {
        'root' => '/root/.ssh',
        default => "${::os::params::home}/${system_user}/.ssh",
    }

    $basedir_ensure = $ensure ? {
        'present' => 'directory',
        'absent'  => 'absent',
        default   => undef,
    }

    file { "ssh-${basedir}":
        ensure => $basedir_ensure,
        name   => $basedir,
        owner  => $system_user,
        group  => $system_user,
        mode   => '0700',
    }

    $defaults = {
        'ensure'      => $ensure,
        'system_user' => $system_user,
    }

    create_resources('ssh::key', $keys, $defaults)
}
