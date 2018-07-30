class librenms::server {
    include '::librenms::vars'

    $pkgdep = ['acl','composer','fping','git','graphviz','imagemagick','mtr-tiny','nmap','python-memcache','python-mysqldb','rrdtool','snmp','whois']
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

    vcsrepo { '/opt/librenms':
        ensure   => present,
   		provider => git,
    	source   => 'https://github.com/librenms/librenms.git',
   	 	revision => '1.41',
		owner    => 'librenms',
		group    => 'librenms',
		force    => true,
  	}

	# Bug https://bugs.launchpad.net/ubuntu/+source/apache2/+bug/1782806
    if $facts['os']['distro']['release']['full'] == 18.04 {
		package { 'libapache2-mod-php': ensure => present, }
	}

 	class { 'apache':
    	default_vhost => false,
    	mpm_module => prefork,
  	}

	if $facts['os']['distro']['release']['full'] != '18.04' {
		class { 'apache::mod::php': }
	}

	class { 'mysql::bindings::php': }

    apache::vhost { $::librenms::vars::vhost:
    	port    => '80',
    	docroot => '/opt/librenms/html',
  	}

 	file { '/etc/cron.d/librenms':
    	ensure => 'link',
    	target => '/opt/librenms/librenms.nonroot.cron',
  	}

    file { '/etc/logrotate.d/librenms':
        ensure => 'link',
        target => '/opt/librenms/misc/librenms.logrotate',
    }

	file {'/opt/librenms':
		owner => 'librenms',
		group => 'librenms',
		recurse => true,
	}


}

