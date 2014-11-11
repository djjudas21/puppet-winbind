# winbind

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Overview

Puppet module to add Linux machines to a Windows domain using Winbind

## Module Description

Puppet module to add Linux machines to a Windows Active Directory domain using Winbind.
As this module fiddles with `smb.conf` it is not compatible with any other module
that affects Samba operations.

This module installs the following facts:

 * `ads_domain` - the name of the domain the system is currently joined to
 * `winbind_version` - the version of winbind currently installed on the system
 * `netbiosname` - a suggested default value for the Netbios name

## Usage

Usage of this module is quite straightforward.

```puppet
class { 'winbind':
  domainadminuser => 'admin',
  domainadminpw   => 'password',
  domain          => 'MYCOMPANY',
  realm           => 'ads.mycompany.org',
  netbiosname     => 'MYWORKSTATION',
  nagioschecks    => true,
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

## Limitations

Written for CentOS 5 and 6, not tested on other platforms. If your distro is not
supported, send a patch!

This module is not compatible with any other Samba/Winbind modules which touch `smb.conf`.

## Development

Pull requests and issues welcome. No guarantees of fixes, but I'll do my best.
