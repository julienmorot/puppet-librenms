class librenms::vars {
    # You MUST customize this for security reasons :
    $dbrootpassword = 'rootpwd'
    $dbname = 'librenms'
    $dbuser = 'librenms'
    $dbpassword = 'librenms'
    $dbhost = 'localhost'
    $vhostname = $fqdn
    $snmpcommunity = 'public'
    $snmpcontact = 'sysadmin@domain.tld'
    $snmplocation = 'Best datacenter on earth'
	$vhostdocumentroot = '/opt/librenms/html'

}

