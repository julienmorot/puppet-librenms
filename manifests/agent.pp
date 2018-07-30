class librenms::agent {
  include '::librenms::vars'
  $service_name = 'snmpd'
  $packages = [ 'snmpd']

  package { $packages :
    ensure => installed,
  }

  file { 'snmpd.conf':
    path    => '/etc/snmp/snmpd.conf',
    ensure  => file,
    mode    => '644',
    owner   => 'root',
    group   => 'root',
    require => Package['snmpd'],
    content => template("${module_name}/snmpd.conf.erb"),
    notify  => Service["snmpd"],
  }

  file { 'etc_default_snmpd':
    path    => '/etc/default/snmpd',
    ensure  => file,
    mode    => '644',
    owner   => 'root',
    group   => 'root',
    require => Package['snmpd'],
    source  => "puppet:///modules/${module_name}/etc-default-snmpd",
    notify  => Service["snmpd"],
  }

  service { $service_name :
    name      => $service_name,
    ensure    => running,
    enable    => true,
    hasrestart => true,
    hasstatus  => true,
  }
}

