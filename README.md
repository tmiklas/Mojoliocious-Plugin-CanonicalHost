# Mojoliocious::Plugin::CanonicalHost

## Intro:
This plugin was designed only to handle redirects from all wired host names
bound to the IP address where your Mojolicious app runs to one name only.
Typical example - www.domain.tld or domain.tld? It may be hard to choose, 
but will be easy to enforce.

## Usage:

<pre>
		$self->plugin('CanonicalHost' => (
			host => 'main_hostname.tld',
			scheme => 'http', 
			port=>80,
 			# redirect_type => 302,
 			# debug => 1,
 			));
</pre>


REQUIRED parameters: host, scheme, port<br/>
OPTIONAL parameters: redirect_type, debug

## Why bother?
- Google doesn't like 'duplicate content' and that's exactly what you 
will get if you server the same content on different hostnames
- I've seen apps that had Access Control Lists or other logic defined per host name and 
failed open - all that was needed to bypas was entry in hosts file to define 
additional host name that had no ACL associated with it (ouch!)

## To Do:
- Proper (pod) documentation
- Tests
- CPAN compatible packaging/installer, even if it never goes to CPAN :-P
