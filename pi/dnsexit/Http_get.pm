package Http_get;
require 5.002;
use Socket;
use strict;

sub new{
	my $self = {};
	$self->{CONTENT} = undef;
	$self->{SUCCESS} = undef;
	bless($self);
	return $self;
}

sub request{
	my $self = shift;
	$self->{CONTENT} = undef;
	$self->{SUCCESS} = undef;
	my $url = shift || return;
	my $port = 80;

	if(substr($url, 0, 7) ne 'http://') {
		return;
	}

	my $host;
	my $uri;
	if((my $first_slash=index($url, '/', 7))!=-1) {
		if((my $dots=rindex($url, ':', $first_slash))>7) {
			$port=substr($url, $dots+1, $first_slash-$dots-1);
			$first_slash=$dots;
		}
		$host=substr($url, 7, $first_slash-7);
		$uri=substr($url, $first_slash);
	}
	else {
		$host=substr($url, 7);
		$uri = '/';
	}
	
	my $iaddr = inet_aton($host) || return;

	my $paddr = sockaddr_in($port, $iaddr);
	my $proto = getprotobyname('tcp');

	socket(SOCKET, PF_INET, SOCK_STREAM, $proto) or return;
	connect(SOCKET, $paddr) or return;

	# flush SOCKET after every write
	select(SOCKET); $|=1; select(STDOUT);

	print SOCKET "GET $uri HTTP/1.0\n";
	print SOCKET "Host: $host\n\n";

	# skip headers
	while (<SOCKET> =~ /[^\s]/) { }
	
	$self->{SUCCESS}=1;
	while (<SOCKET>) {
		$self->{CONTENT}.=$_ ;
	}

	close SOCKET;
	return $self;
}

sub is_success {
	my $self = shift;
	return $self->{SUCCESS};
}

sub content {
	my $self = shift;
	return $self->{CONTENT};
}

1;
