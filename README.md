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
that affects Samba operations, unless a non default location for `smb.conf` is specified as 
a parameter.

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
  winbind_max_domain_connections => 8,
  winbind_max_clients            => 500,
  osdata                         => false,
  machine_password_timeout       => 0,
  smbconf_file                   => '/etc/samba/custom-smb.conf'
  winbind_use_default_domain     => 'no',
  winbind_offline_logon          => 'false',
  template_shell                 => '/bin/false',
  template_homedir               => '/home/%U',
  uidrange                       => '16777216-33554431',
  winbind_clients_package        => 'samba-winbind-clients',
  samba_client_package           => 'samba-client',
  samba_winbind_package          => 'samba-winbind',
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

### `smbconf_file`

Specify a custom disk location for the smb.conf file. Useful if another module is managing
samba shares in the default configuration file.

### `winbind_max_domain_connections`

Specify the maximum number of simultaneous connections that the winbindd daemon
should open to the domain controller of one domain. Setting this parameter to a
value greater than 1 can improve scalability with many simultaneous winbind requests,
some of which might be slow. Default: `1`

### `winbind_max_clients`

Specify the maximum number of clients the winbindd daemon can connect with. Default: `200`.

### `osdata`

If true, provide values for `osName` and `osVer` (e.g. `CentOS` and `7`). Default: `false`.

### `machine_password_timeout`

This parameter specifies how often machine password will be changed, in seconds. The default is one week (expressed in seconds), the same as a Windows NT Domain member server. Default: `604800`.

### `winbind_use_default_domain`

Causes winbind to treat any username that isn't qualified with a domain name as a username in the domain to which winbind is joined. Default: `no`

### `winbind_offline_logon`

Allow offline logon with cached credentials Default: `false`
### `template_shell`

Default user shell. Default: `/bin/false`

### `template_homedir`

Default location of user's home directory. Default: `/home/%U`

### `uidrange`

Range of UIDs that can be allocated. Default: `16777216-33554431`

### `winbind_clients_package`

Package name of Winbind client tools. Default: `samba-winbind-clients`

### `samba_client_package`

Package name of Samba client. Default: `samba-client`

### `samba_winbind_package`

Package name of Winbind libraries. Default: `samba-winbind`

## Limitations

Written for CentOS 5 and 6 with Samba 3.x. not tested on other platforms. If your distro is not in the list
but you know it works, let me know and I'll update the list. If the module needs some extra
work to enable support for your distro, send a patch!

This module is not compatible with any other Samba/Winbind modules which touch `smb.conf` or
handle Winbind packages.

## Development

Pull requests and issues welcome. No guarantees of fixes, but I'll do my best.

There are lots of [additional options for Winbind](https://www.samba.org/samba/docs/man/manpages/smb.conf.5.html)
that can be specified in `smb.conf`. If you're feeling keen, edit the template, manifest and README
and add these options to the module as parameters.
