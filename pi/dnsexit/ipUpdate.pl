#!/usr/bin/perl -w
###################################################
##
##  DnsExit.Com Dynamic IP update script
##  v1.7
##
##################################################
BEGIN { my $PROGRAMDIR=`dirname $0`; chop $PROGRAMDIR; push @INC, $PROGRAMDIR; };
use strict;
use Http_get;
#
# Get config variables
#
my $cfile = "/etc/dnsexit.conf";
my %keyVal=();
open (CFG, "< $cfile") || (print STDERR "Fail open config file $cfile. You need to run dns-setup.pl script" && exit );
while (<CFG>)
{
  (my $line = $_ ) =~ s/\s+$//;

  if ( length( $line ) < 2 || ( $line =~ /^\s*#/ ) )
  {
    next;
  }
  my ($key, $value) = split(/=/, $line);
  $keyVal{$key} = $value;
}
my $ipfile   = $keyVal{"cachefile"} || '/tmp/dnsexit-ip.txt';
my $pidfile  = $keyVal{"pidfile"} || '/var/run/ipUpdate.pid';
my $daemon   = lc($keyVal{"daemon"}) || 'yes';
my $interval = $keyVal{"interval"} || 600;
my $logfile  = $keyVal{"logfile"} || '/var/log/dnsexit.log';

if ( ! ( $daemon eq "yes" ) )
{
  my $ip = getProxyIP();
  
  my $ipFlag = isIpChanged($ip);
  if ( $ipFlag == 1 )
  {
    mark("INFO", "100", "IP is not changed from last successful update");
    exit 0;
  }
  postNewIP( $ip );
}
else
{
  check_running();
  daemonize();
  while(1)
  {
    mark("INFO", "100", "Started in daemon mode");
    my $ip = getProxyIP();  
    my $ipFlag = isIpChanged($ip);
    if ( $ipFlag == 1 )
    {
      mark("INFO", "100", "IP is not changed from last successful update");
    } 
    else
    {
      postNewIP( $ip );
    }
    sleep( $interval );
  }
}
exit 0;
#-----------------------------------------------------
#-- Sub Routines
#-----------------------------------------------------
sub postNewIP
{
  my $newip = shift ( @_ );
  my $get = new Http_get;
  my $url = $keyVal{"url"};
  my $login = $keyVal{"login"};
  my $password = $keyVal{"password"};
  my $host = $keyVal{"host"};
  my $posturl = "${url}?login=${login}&password=${password}&host=${host}";
  if ( $newip =~ /\d+\.\d+\.\d+\.\d+/ )
  {
    $posturl = ${posturl} . "&myip=${newip}";
  }

  my $response = $get->request($posturl);
  if ($response->is_success)
  {
    #record successful update of the ip address
    
    my $result = $response->content;    
    if ( $result =~ /(\d+)=(.+)/ )
    {
      mark("Success", "$1", "$2");
      open S, "> $ipfile";
      print S $newip;
      close S;
    }
    else
    {
      mark("ERROR", "-99", "Return content format error");
    }

  }
  else
  {
    mark("ERROR", $response->code, $response->message);
  }

}

sub isIpChanged
{
  my $newip = shift(@_);
  return 0 unless -e $ipfile;
  open SS, "< $ipfile";
  my $preip = <SS>;
  close SS;
  #print "new=[$newip] old=[$preip]";
  if (!($newip eq $preip))
  {
    return 0;
  }
  return 1;
}
sub getProxyIP
{
  my $get = new Http_get;
  my $ipServs = $keyVal{"proxyservs"};
  my @servs = split(/;/, $ipServs);
  foreach my $server ( @servs )
  {
    my $myUrl = "http://" . $server;
    my $response = $get->request($myUrl);
    if ($response->is_success)
    {
      if ( $response->content =~ /\D*(\d+\.\d+\.\d+\.\d+).*/ )
      {
    	mark("INFO", "100", "$myUrl says your IP address is: $1");
    	return ( $1 );
      }
      else
      {
    	mark("ERROR", "-100", "Return message format error.... Fail to grep the IP address from ".$myUrl);
      }
    }
  }
  mark("ERROR", "-99", "Fail to get the proxy IP of your machine");
  return "";
}
sub mark
{
  my ($type, $code, $message) = @_;
  open (LOGFILE, ">>$logfile");
  my $msg=localtime()."\t$type\t".$code."\t".$message."\n";
  print $msg;
  print LOGFILE $msg;
  close LOGFILE;
}

# Daemonize the process and write pid to pidfile
sub daemonize 
{
  print "$0 started.\nLog file: $logfile\n";
  open (STDIN, '/dev/null')   or die "Can't read /dev/null: $!";
  open (STDOUT, '>>/dev/null') or die "Can't write to /dev/null: $!";
  open (STDERR, '>>/dev/null') or die "Can't write to /dev/null: $!";
  defined(my $pid = fork)   or die "Can't fork: $!";
  if ($pid ) 
  {
    open (PIDFILE, ">$pidfile");
    print PIDFILE $pid;
    close PIDFILE;
    exit;
  }
  umask 0;
}

sub check_running
{
  my $program = $0;
  my $running = `/bin/ps aux| grep $program | grep "/usr/bin/perl" | grep -v "grep $program" | grep -v " vim "`;
  #return 1 if(length($running) < 2);
  my (@line) = split("\n", $running);
  my $rcount = scalar (@line) - 1;
  if( $rcount > 0 )
  {
    print "Another instance of $program is running. \n..try to kill it........\n";
    my $lpid = `cat $pidfile`;
    system("kill -9 $lpid");
    sleep( 2 );
  }
}
