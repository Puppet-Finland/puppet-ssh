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
    String                   $system_user = $title,
    Enum['present','absent'] $ensure = 'present',
    Hash                     $keys = {}
)
{
    include ::ssh::params

    if $::kernel == 'windows' {
        $basedir = "C:\\Users\\${system_user}\\.ssh"
        $owner = undef
        $group = undef
        $mode = undef
    } else {
        $basedir = $system_user ? {
            'root' => '/root/.ssh',
            default => "${::os::params::home}/${system_user}/.ssh",
        }
        $owner = $system_user
        $group = $system_user
        $mode = '0700'
    }

    $basedir_ensure = $ensure ? {
        'present' => 'directory',
        'absent'  => 'absent',
        default   => undef,
    }

    file { "ssh-${basedir}":
        ensure => $basedir_ensure,
        name   => $basedir,
        owner  => $owner,
        group  => $group,
        mode   => $mode,
    }

    $defaults = {
        'ensure'      => $ensure,
        'system_user' => $system_user,
    }

    create_resources('ssh::key', $keys, $defaults)
}
