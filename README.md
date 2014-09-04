# winbind

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Puppet module to add Linux machines to a Windows domain using Winbind

## Module Description

Puppet module to add Linux machines to a Windows Active Directory domain using Winbind.
As this module fiddles with `smb.conf` it is not compatible with any other module
that affects Samba operations.

This module installs the following facts:

 * `ads_domain`
 * `winbind_version`

## Usage

Usage of this module is quite straightforward.

```
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

Netbios name of the local machine. Optional, max 15 chars, defaults to `$::uniqueid`.

### `nagioschecks`

Whether to enable Nagios check for domain membership. Has hard-coded parameters and may
not work for you with modification. Optional boolean, defaults to `false`.

## Reference

Here, list the classes, types, providers, facts, etc contained in your module.
This section should include all of the under-the-hood workings of your module so
people know what the module is touching on their system but don't need to mess
with things. (We are working on automating this section!)

## Limitations

Written for CentOS 5 and 6, not tested on other platforms. If your distro is not
supported, send a patch!

This module is not compatible with any other Samba/Winbind modules which touch `smb.conf`.

## Development

Pull requests and issues welcome. No guarantees of fixes, but I'll do my best.
