class librenms::server {
    include '::librenms::vars'

    $pkgdep = ['acl','composer','fping','git','graphviz','imagemagick','mtr-tiny','nmap','python-memcache','python-mysqldb','rrdtool','snmp','snmpd','whois']
    package { $pkgdep: ensure => present }

    class {'::mysql::server':
        root_password    => $::librenms::vars::dbrootpassword,
    }

    mysql::db { $::librenms::vars::dbname:
        user     => $::librenms::vars::dbuser,
        password => $::librenms::vars::dbpassword,
        host     => $::librenms::vars::dbhost,
        grant    => ['ALL'],
    }

}
