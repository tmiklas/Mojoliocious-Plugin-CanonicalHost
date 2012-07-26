package Mojolicious::Plugin::CanonicalHost;
use Mojo::Base 'Mojolicious::Plugin';
my $VERSION='0.01';

sub register {
    my ( $self, $app, $param ) = @_;

	# REQUIRED: canonical host name
	my $host = $param->{host} || undef;
	
	# REQUIRED: redirect to http/https/ftp scheme, if defined
	my $scheme = $param->{scheme} || undef;
	
	# REQUIRED: rewrite port if defined
	my $port = $param->{port} || undef;
	
	# OPTIONAL: default redirect type, 301 (perm) is SEO friendly, unlike 302 (temp)
	my $redirect_type = $param->{redirect_type} || 301;
	
	# OPTIONAL: debug - print to STDER what's done
	my $debug = $param->{debug} || 0;
	
	# default ports so we can have clean URLs from time to time ;)
	my %default_port = ('http' => 80, 'https' => 443);
	
	$app->hook(
		before_dispatch => sub {
			if ($_[0]->req->url->base->host !~ /^$param->{host}$/i) {
				# host is not canonical - rewrite and redirect
				# poor man deep copy, to avoid modifications in global namespace that should be r/o
				my ($lscheme, $lhost, $lport, $lpath, $leading_slash, $trailing_slash) = (
					lc($_[0]->req->url->base->scheme),
					scalar lc($_[0]->req->url->base->host),
					scalar $_[0]->req->url->base->port,
					scalar (join '/', @{$_[0]->req->url->path->parts}),
					scalar $_[0]->req->url->base->path->leading_slash,
					scalar $_[0]->req->url->base->path->trailing_slash,
					);
				# overlay new parameters
				$lscheme = $scheme if defined $scheme;
				$lport = $port if defined $port;
				# rebuilding URL including path
				my $new_location = $lscheme. '://' . $host;
				$new_location .= ':' . $lport if $lport != $default_port{$lscheme};
				$new_location .= '/' . $lpath if $lpath;
				$new_location .= '/' if $trailing_slash;
				$_[0]->res->code($redirect_type);
				$_[0]->redirect_to($new_location);
				print STDERR "Mojolicious::Plugin::CanonicalHost $redirect_type redirected ",  $_[0]->req->url->to_abs, " to $new_location\n" if $debug;
			}
			return 1;
		}
	) if defined $host and defined $port and defined $scheme;
}

1;
