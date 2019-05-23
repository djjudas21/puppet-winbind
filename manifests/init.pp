# Install samba and winbind, and join box to the domain
class winbind (
  String $domainadminuser,
  String $domainadminpw,
  String $domain,
  String $realm,
  String $createcomputer = '',
  Integer $machine_password_timeout = 604800,
  String $netbiosname = $::netbiosname,
  Integer $winbind_max_domain_connections = 1,
  Integer $winbind_max_clients = 200,
  String $winbind_use_default_domain = 'no',
  String $winbind_offline_logon = 'no',
  String $template_shell = '/bin/false',
  String $template_homedir = '/home/%U',
  Boolean $osdata = false,
  String $uidrange = '16777216-33554431',
  String $smbconf_file = '/etc/samba/smb.conf',
  String $winbind_clients_package = 'samba-winbind-clients',
  String $samba_client_package = 'samba-client',
  String $samba_winbind_package = 'samba-winbind',
  String $samba_conf_template = 'winbind/smb.conf.erb',
  String $idmap_config_backend = 'tdb',
  String $idmap_config_range = $uidrange,
) {

  # Main samba config file
  file { 'smb.conf':
    name    => $smbconf_file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template($samba_conf_template),
    require => Package[$samba_client_package],
    notify  => [ Exec['add-to-domain'], Service['winbind'] ],
  }

  # Install packages
  if($winbind_clients_package) {
    package { $winbind_clients_package:
      ensure  => installed,
    }
  }
  if($samba_winbind_package) {
    package { $samba_winbind_package:
      ensure  => installed,
    }
  }
  if($samba_client_package) {
    package { $samba_client_package:
      ensure  => installed,
    }
  }

  # If createcomputer is defined, prepend it with the argument
  if ($createcomputer != '') {
    $createcomputerarg = "createcomputer='${createcomputer}'"
  }
  else {
    $createcomputerarg = ''
  }

  # If $osdata=true, populate the string
  if ($osdata) {
    $osdataarg = "osName='${::operatingsystem}' osVer=${::operatingsystemmajrelease}"
  }
  else {
    $osdataarg = ''
  }

  # Add the machine to the domain
  exec { 'add-to-domain':
    command => "net ads join -s ${smbconf_file} -U ${domainadminuser}%${domainadminpw} ${createcomputerarg} ${osdataarg}",
    onlyif  => "wbinfo --own-domain | grep -v ${domain}",
    path    => '/bin:/usr/bin',
    notify  => Service['winbind'],
    require => [ File['smb.conf'], Package[$winbind_clients_package] ],
  }

  file_line { 'let-winbind-use-custom-smbconf-file':
    path   => '/etc/sysconfig/samba',
    line   => "WINBINDOPTIONS=\" -s ${smbconf_file}\"",
    match  => '^WINBINDOPTIONS=.*$',
    notify => Service['winbind'],
  }

  # Start the winbind service
  service { 'winbind':
    ensure     => running,
    require    => [ File['smb.conf'], Package[$samba_winbind_package] ],
    subscribe  => File['smb.conf'],
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
  }
}
