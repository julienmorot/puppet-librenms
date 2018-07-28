class librenms::server {
    include '::librenms::vars'

    $pkgdep = ['acl','composer','fping','git','graphviz','imagemagick','mtr-tiny','nmap','python-memcache','python-mysqldb','rrdtool','snmp','snmpd','whois']
    package { $pkgdep: ensure => present }

    $override_options = {
        '[mysqld]' => {
            innodb_file_per_table=>1,
            sql-mode=>"",
            lower_case_table_names=>0,
        }
    }

    class {'::mysql::server':
        root_password    => $::librenms::vars::dbrootpassword,
        override_options        => $override_options
    }

    mysql::db { $::librenms::vars::dbname:
        user     => $::librenms::vars::dbuser,
        password => $::librenms::vars::dbpassword,
        host     => $::librenms::vars::dbhost,
        grant    => ['ALL'],
    }

    user { 'librenms':
        ensure     => 'present',
        home       => '/opt/librenms',
        managehome => true,
        shell      => '/bin/bash',
        groups     => 'www-data',
    }

}
