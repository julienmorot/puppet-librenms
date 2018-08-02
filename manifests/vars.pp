class librenms::vars {
    # You MUST customize this for security reasons :
    $dbrootpassword = 'rootpwd'
    $dbname = 'librenms'
    $dbuser = 'librenms'
    $dbpassword = 'librenms'
    $dbhost = 'localhost'
    $vhostname = $fqdn
    $snmpcommunity = 'mycommunity'
	$snmpsubnet = '192.168.0.0/16'
    $snmpcontact = 'sysadmin@domain.tld'
    $snmplocation = 'Best datacenter on earth'
    $vhostdocumentroot = '/opt/librenms/html'
    $phptimezone = 'Europe/Paris'

}

