class librenms::server {
    include '::librenms::vars'
	$phpver = "7.2"

    $pkgdep = ['acl','composer','fping','git','graphviz','imagemagick','mtr-tiny','nmap','python-memcache','python-mysqldb','rrdtool','snmp','whois']
    package { $pkgdep: ensure => present }

    $override_options = {
        'mysqld' => {
            innodb_file_per_table=>1,
            sql-mode=>"''",
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
		collate	 => 'utf8_unicode_ci',
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
		group    => 'www-data',
		force    => true,
  	}

    if $facts['os']['distro']['release']['full'] == 18.04 {
		$phpver = "7.2"
	}
	if $facts['os']['distro']['release']['full'] == 16.04 {
        $phpver = "7.0"
    }

	package { 'libapache2-mod-php': ensure => present, }
	exec { "a2enmod php${$phpver}":
		path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
		unless   => ["test -f /etc/apache2/mods-enabled/php${$phpver}.load"],
		notify  => Service["apache2"],
	}
    exec { "a2enmod rewrite":
        path => ["/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        unless   => ["test -f /etc/apache2/mods-enabled/rewrite.load"],
        notify  => Service["apache2"],
    }

	file_line { 'php_timezone':
  		ensure => present,
  		path   => "/etc/php/${$phpver}/apache2/php.ini",
  		line   => "date.timezone = ${::librenms::vars::phptimezone}",
  		match  => '^date.timezone',
		notify  => Service["apache2"],
	}

	Service { "apache2" :
    	ensure    => running,
	    enable    => true,
	}

	file { '/etc/apache2/sites-available/vhost.librenms.conf':
	    ensure  => file,
	    mode    => '644',
	    owner   => 'root',
	    group   => 'root',
    	content => template("${module_name}/vhost.librenms.conf.erb"),
	}

    file { '/etc/apache2/sites-enabled/vhost.librenms.conf':
        ensure => 'link',
        target => '/etc/apache2/sites-available/vhost.librenms.conf',
		notify  => Service["apache2"],
    }

	$librenmspkgdep = ["php${phpver}-curl","php${phpver}-gd","php${phpver}-xml","php${phpver}-mbstring", "php${phpver}-mysql"]
    package { $librenmspkgdep: ensure => present }

    exec { 'composer_librenms':
        command  => "./scripts/composer_wrapper.php install --no-dev && touch /opt/librenms/.composer_librenms",
		cwd		 => "/opt/librenms",
        path     => '/usr/bin:/usr/sbin:/bin:/sbin',
        provider => shell,
        unless   => ['test -f /opt/librenms/.composer_librenms'],
    }

 	file { '/etc/cron.d/librenms':
    	ensure => 'link',
    	target => '/opt/librenms/librenms.nonroot.cron',
  	}

    file { '/etc/logrotate.d/librenms':
        ensure => 'link',
        target => '/opt/librenms/misc/librenms.logrotate',
    }

	file { '/etc/apache2/sites-enabled/000-default.conf':
		ensure => 'removed',
		notify  => Service["apache2"],
	}

	file {'/opt/librenms':
		owner => 'librenms',
		group => 'www-data',
		recurse => true,
	}


}

