What is it?
===========

A puppet module that installs apache with mod_evasive and mod_security 
(optional).  This module has been written and tested on CentOS 6 and is 
primarily used for configuring apache as a proxy for Tomcat via AJP and other
services via TCP, but it also has support for mod_passenger, mod_python, and
mod_wsgi as well.  

Disabling mod_security by vhost, rule, or IP are provided.  JSON logging for
vhosts allowing easy import into logstash is available.

Support for SSL certificates, password files, or any other sensitive 
information may be installed installed to a limted access directory through
apache::securefile.

Monitoring by [sensu](http://sensuapp.org) is provided, but
additional monitoring solutions can easily be added.


Usage:
------

Generic apache install
<pre>
  class { 'apache': }
</pre>

Adding a NameVirtualHost on port 80:
<pre>
  apache::namevhost { '80': }
</pre>

Generic config files:
<pre>
  apache::cfgfile { 'myapp':
    content   => template('mymodule/apache.cfg'),
    filename  => 'myapp.cfg',
  }
</pre>

Tomcat AJP proxy with http -> https redirect:
<pre>
  apache::vhost { 'example-http':
    port            => 80,
    serverName      => $::fqdn,
    serverAlias     => [ 'example.com' ],
    redirectToHTTPS => true,
    logstash        => true,
  }

  apache::vhost { 'example-https':
    serverName        => $::fqdn,
    serverAlias       => [ 'example.com' ],
    proxy             => true,
    proxyTomcat       => true,
    port              => 443,
    rewrite_to_https  => true,
    modSecOverrides   => true,
    modSecRemoveById  => [ '11111' ],
    logstash          => true,
  }
</pre>

TCP proxy:
<pre>
  apache::vhost { 'newservice':
    port              => 80,
    serverName        => $::fqdn,
    serverAlias       => [ 'newservice.example.com' ],
    proxy             => true,
    proxyThin         => true,
    thinPort          => 3000,
    thinNumServers    => 3,
    modSecOverrides   => true,
    modSecRemoveById  => [ '970901', '960015' ],
    logstash          => true,
  }
</pre>

Static content:
<pre>
  apache::vhost { 'example.com':
    serverName        => $::fqdn,
    serverAlias       => ['www.example.com', 'example.com'],
    docroot           => '/var/www/html/example',
    modSecOverrides   => true,
    modSecRemoveById  => [ '970901', '960015' ];
  }
</pre>


Known Issues:
-------------
Only tested on CentOS 6

TODO:
____
[ ] Make mod_evasive optional
[ ] Make mod_status optional and configurable
[ ] Allow disabling mod_security by file
[ ] Improve documentation, complex module

License:
_______

Released under the Apache 2.0 licence


Contribute:
-----------
* Fork it
* Create a topic branch
* Improve/fix (with spec tests)
* Push new topic branch
* Submit a PR