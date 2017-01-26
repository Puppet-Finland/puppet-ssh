# ssh

A Puppet module for managing ssh

# Module usage

A Hiera example:

    classes:
        - ssh
    
    ssh::userconfigs:
        john:
            keys:
                john-id_dsa:
                    basename: 'id_dsa'
                john-id_dsa.pub:
                    basename: 'id_dsa.pub'
                    secret: false
                ec2.pem:
                    basename: 'ec2.pem'

The SSH key files should be placed on the Puppet fileserver and named as 
ssh-${title}. In the above case this would translate to

    ssh-john-id_dsa
    ssh-john-id_dsa.pub
    ssh-ec2.pem

The forced file prefix is there to lessen the chance of filename clashes with
other modules.

For details, see 

* [Class: ssh](manifests/init.pp)
* [Define: ssh::userconfig](manifests/userconfig.pp)
* [Define: ssh::key](manifests/key.pp)

# Dependencies

See [metadata.json](metadata.json).

# Operating system support

This module has been tested on

* Debian 8
* Fedora 21
* Windows 7 (user configs only, no ssh installation)

Any *NIX-style should work out of the box or with minor modifications.

For details see [params.pp](manifests/params.pp).
