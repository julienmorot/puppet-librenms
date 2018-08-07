<<<<<<< HEAD
# librenms

#### Table of Contents

1. [Description](#description)
1. [Usage - Configuration options and additional functionality](#usage)

## Description

LibreNMS is a powerfull to monitor yur network with SNMP. This modules 
help you to configure your server and your agents.
It's clearly only functionnal with Debian/Ubuntu and I've only tests this module 
with Ubuntu 18.04. 

## Usage

Configure your variables in manifests/vars.pp (I know, not the best way to do that with Puppet).

For a server :

node 'server' {
    include librenms::server
}

For a monitored system :

node 'agent' {
    include librenms::agent
}




