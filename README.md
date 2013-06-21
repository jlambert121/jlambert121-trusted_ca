What is it?
===========

A puppet module that installs trusted certificate authorities onto RHEL-based
systems.  This is useful when you have an internal CA you would like to have
your hosts trust.


Usage:
------

Install the internal CA for example.com
<pre>
  trusted_ca::ca { 'example.org.local':
    source  => puppet:///data/ssl/example.com.pem
  }
</pre>


Known Issues:
-------------
Only tested on CentOS 6


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
