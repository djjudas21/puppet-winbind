# winbind

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Overview

Puppet module to add Linux machines to a Windows domain using Winbind. It installs the
bare minimum needed to achieve this, and notably does not install or configure the Samba
server.

## Module Description

Puppet module to add Linux machines to a Windows Active Directory domain using Winbind.
As this module fiddles with `smb.conf` it is not compatible with any other module
that affects Samba operations.

This module installs the following facts:

 * `ads_domain` - the name of the domain the system is currently joined to
 * `winbind_version` - the version of winbind currently installed on the system
 * `netbiosname` - a suggested default value for the Netbios name

## Usage

Usage of this module is quite straightforward. A minimal example which accepts most
defaults is:

```puppet
class { 'winbind':
  domainadminuser => 'admin',
  domainadminpw   => 'password',
  domain          => 'MYCOMPANY',
  realm           => 'ads.mycompany.org',
}
```

This example is more extensive and shows every possible option:

```puppet
class { 'winbind':
  domainadminuser                => 'admin',
  domainadminpw                  => 'password',
  domain                         => 'MYCOMPANY',
  realm                          => 'ads.mycompany.org',
  createcomputer                 => 'Computers/BusinessUnit/Department/Servers',
  netbiosname                    => 'MYWORKSTATION',
  nagioschecks                   => true,
  winbind_max_domain_connections => 8,
  winbind_max_clients            => 500,
  osdata                         => false,
}
```

### `domainadminuser`

Username of Windows domain admin with sufficient rights to add machines to AD. Required.

### `domainadminpw`

Password of Windows domain admin with sufficient rights to add machines to AD. Required.

### `domain`

NT4-style domain name of your site, e.g. `MYCOMPANY`. Required.

### `realm`

Realm of your site, e.g. `ads.mycompany.org`. Required.

### `createcomputer`

OU to create the machine account in. Optional.

### `netbiosname`

Netbios name of the local machine. Optional, max 15 chars, defaults to `$::netbiosname`.

### `nagioschecks`

Whether to enable Nagios check for domain membership. Has hard-coded parameters and may
not work with your Puppet environment. Optional boolean, defaults to `false`.

### `winbind_max_domain_connections`

Specify the maximum number of simultaneous connections that the winbindd daemon
should open to the domain controller of one domain. Setting this parameter to a
value greater than 1 can improve scalability with many simultaneous winbind requests,
some of which might be slow. Default: `1`

### `winbind_max_clients`

Specify the maximum number of clients the winbindd daemon can connect with. Default: `200`.

### `osdata`

If true, provide values for `osName` and `osVer` (e.g. `CentOS` and `7`). Default: `false`.

## Limitations

Written for CentOS 5 and 6 with Samba 3.x. not tested on other platforms. If your distro is not in the list
but you know it works, let me know and I'll update the list. If the module needs some extra
work to enable support for your distro, send a patch!

This module is not compatible with any other Samba/Winbind modules which touch `smb.conf` or
handle Winbind packages.

## Development

Pull requests and issues welcome. No guarantees of fixes, but I'll do my best.

There are lots of [additional options for Winbind](https://www.samba.org/samba/docs/man/manpages/smb.conf.5.html)
that can be specified in `smb.conf`. If you're feeling keen, edit the template and manifest
and add these options to the module as parameters.
