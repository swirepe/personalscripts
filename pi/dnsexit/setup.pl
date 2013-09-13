#!/usr/bin/perl -w
####################################################
##
##  DnsExit.Com Dynamic IP update setup script
##  v1.70
##
##  Purpose to further automate setup for use by
##  Arch Linux and allow use of systemd for startup.
##
####################################################

use Http_get;
use strict;

my $cfile = '/etc/dnsexit.conf';
my $proxyservs = 'ip.dnsexit.com;ip2.dnsexit.com;ip3.dnsexit.com';
my $logfile = '/var/log/dnsexit.log';
my $cachefile = '/tmp/dnsexit-ip.txt';
my $pidfile = '/var/run/ipUpdate.pid';
my $siteurl='http://update.dnsexit.com';
my $geturlfrom = "$siteurl/ipupdate/dyndata.txt";

my $URL_VALIDATE="$siteurl/ipupdate/account_validate.jsp";
my $URL_DOMAINS="$siteurl/ipupdate/domains.jsp";
my $URL_HOSTS="$siteurl/ipupdate/hosts.jsp";

my $MSG_WELCOME= "Wecome to DNSExit.Com Dynamic IP update setup script.\n".
                 "Please run this script as root user.\n".
                 "Please follow instructions to setup our script.\n\n";
my $MSG_USERNAME="Enter the username to dnsexit.com: ";
my $MSG_PASSWORD="Enter password for your username: ";
my $MSG_CHECKING_USERPASS="Validating your login credentials...\n";
my $MSG_CHECKING_DOMAINS="Fetching your DNS domains. It may take a while...\n".
                         "Note: You should setup DNS for the domain first at your web account to get the domain listed below.\n\n";
my $MSG_USERPASSOK="Login Successfully...\n\n";
my $MSG_HOSTS="Please type password for your username:\n";
my $MSG_SELECT_DOMAINS="Please select the domains to update:\n";
my $MSG_FETCHING_HOSTS="Feching hosts in your domains. This may take a while...\n";
my $MSG_SELECT_HOSTS="Please select host(s) to be updated:\n";
my $MSG_SELECT_HOSTS_AFTER="Note: to select multiple hosts, separate them by space\nYour selection: ";
my $MSG_YOU_HAVE_SELECTED="You have selected the following hosts to be updated:\n";
my $MSG_SELECT_PROXY="If you want to use the IP address of your proxy server instead of the\n".
                     "IP of the local host, set the value to \"yes\"\n";
my $MSG_PROXY_SEL="Your choice [no]: ";
my $MSG_SELECT_DAEMON="Do you want to run it as a daemon?\n";
my $MSG_SELECT_INTERVAL="How often (in minutes) should the program checks IP changes ?\n".
                        "IP will be posted to dnsExit.com only when IP address has been\n".
                        "changed from the last update (minimum 3 minutes):\n";
my $MSG_INTERVAL_SEL="Your choice [10]: ";
my $MSG_SELECT_PIDFILE="Select path to pidfile.\n";
my $MSG_PIDFILE_SEL="Your choice [/var/run/ipUpdate.pid]: ";
my $MSG_PIDFILE_BAD="You have selected invalid file name.\n";
my $MSG_GENERATING_CFG="Generating config file: ";
my $MSG_DONE="Done creating config file. You can run the script now.\n".
             "To do it you can run ipUpdate.pl or use init script.\n\n".
             "File '$cachefile' will cache the ip address of\n".
             "the last successful IP update to our system. For next\n".
             "update, if the IP stays the same, the update request\n".
             "won't be sent to our server. You can simply change the\n".
             "IP at dnsexit-ip.txt file to force the update to DNSEXIT.\n\n";
my $MSG_PATHS="Here are paths to some intresting files:\n";
my $MSG_END="Don't forget to read README.txt file in doc directory!\n";


my $ERR_DOMAINS="Can't get list of your domains from the server";
my $ERR_NO_DOMAINS="You don't have any domains with DNS. You should login to your account ".
                  "at www.dnsexit.com and setup DNS for your domains first.\n";
my $ERR_NO_HOSTS_SELECTED="You have not selected any hosts. Exiting...\n";
my $ERR_NO_URL="Can't fetach url info from dnsexit.com. Please try again later...\n";

my $get = new Http_get;
print $MSG_WELCOME;

#
# Delete ald cache file
#
unlink $cachefile;

#
# Get url from dnsexit.com
#
my $url;
$get->request($geturlfrom);
if($get->is_success) {
	my $result = $get->content;
	if ( $result =~ /url=(.+)/ ) {
		$url=$1;
		if((my $chr=chop($url)) ne "\n"){
			$url.=$chr;
		}
	}
}
if(!$url) {
	print $ERR_NO_URL;
	exit;
}
#
# Get username/password and validate it.
#
my $userpassok=0;
my $message=undef;
my $username;
my $password;
do {
	print "\nError: $message\n\n" if($message);
	# Get username
        $username=ask_value($MSG_USERNAME);
	# Get password
        $password=ask_value($MSG_PASSWORD);
        $password =~ s/ /%20/g;
	print $MSG_CHECKING_USERPASS;
	# Check username/password
	$get->request($URL_VALIDATE."?login=$username&password=$password");
	if($get->is_success) {
		my $result = $get->content;
		if ( $result =~ /(\d+)=(.+)/ ) {
			$userpassok=$1;
			$message=$2;
			if((my $chr=chop($message)) ne "\n"){
				$message.=$chr;
			}
		}
	}
} until($userpassok==0);
print $MSG_USERPASSOK;

#
# Get list of domains and ask user which of them should be explored
#
my @domains;
print $MSG_CHECKING_DOMAINS;
$get->request($URL_DOMAINS."?login=$username&password=$password");
if($get->is_success) {
	my $result = $get->content;
	if ( $result =~ /(\d+)=(.+)/ ) {
		$message=$2;
		if((my $code=$1)==0) {
			@domains=split(/ +/, $message);
		}
		elsif($code==1) {
			print "\n$ERR_NO_DOMAINS\n\n";
			exit;
		}
		else {
			print"\nError: $message\n\n";
			exit;
		}
	}
	else {
		print "\n$ERR_DOMAINS\n\n";
		exit;
	}
}
else {
	print "\n$ERR_DOMAINS\n\n";
	exit;
}

my @selected = make_select(\@domains, $MSG_SELECT_DOMAINS, 1 );

my @hosts;

#
# Get list of hosts from selected domains and ask user which should be added
# to the config file.
#
print $MSG_FETCHING_HOSTS;
foreach my $domain (@selected) {
	$get->request($URL_HOSTS."?login=$username&password=$password&domain=$domain");
	if($get->is_success) {
		my $result=$get->content;
		if ( $result =~ /(\d+)=(.+)/ ) {
			$message=$2;
			if((my $code=$1)==0) {
			my @myhosts=split(/\ /, $message);
				foreach my $host (@myhosts) {
					$host =~ s/\s+//g;
					push (@hosts,$host);
				}
			}
		}
	}
}

@selected = make_select(\@hosts, $MSG_SELECT_HOSTS, 1 );
my $hosts;
print "\n".$MSG_YOU_HAVE_SELECTED;
foreach my $sel ( @selected ) {
	$sel =~ s/\s+//g;	
	print "\t$sel\n";
	$hosts.=$sel;
	$hosts.=';';
}
chop $hosts;

#
# Ask user whants daemon mode.
#
my $daemon= confirm("yes", "no", "Your choice [yes]: ", $MSG_SELECT_DAEMON);

#
# If deamon=YES then ask for an interval
#
print "\n";
my $interval = 0;
my $autostart="no";
if($daemon eq 'yes') {
  print $MSG_SELECT_INTERVAL;
  while( $interval < 3 ) {
    $interval = ask_value($MSG_INTERVAL_SEL, "10");
    print "Error: minimum 3 minutes\n" if ( $interval < 3 || ! ( $interval =~ /^\d+$/ ) );
  }
  $interval *= 60; #convert to seconds
  #
  # Ask if want to auto start after reboot
  #
  $autostart=confirm("yes", "no", "Your choice [yes]: ", "Do you want to autostart the IPUpdate script at system startup?\n");
  if($autostart eq "yes")
  {
    my @seldirs=( &programdir, "/usr/local/bin", "/usr/sbin");
    my $sdir=make_select(\@seldirs, "Please select the directory to install the script:\n", 0);
    set_autostart($sdir);
  }
}
$interval = 600 if $interval == 0;
#
# Generate config and .service files
#
print "\n".$MSG_GENERATING_CFG . " $cfile\n";
open (CFG, "> $cfile") || die "Fail open config file $cfile. Please check if have proper permissions.";
print CFG "login=$username\n";
print CFG "password=$password\n";
print CFG "host=$hosts\n";
print CFG "daemon=$daemon\n";
print CFG "autostart=$autostart\n";
print CFG "interval=$interval\n";
print CFG "proxyservs=$proxyservs\n";
print CFG "pidfile=$pidfile\n";
print CFG "logfile=$logfile\n";
print CFG "cachefile=$cachefile\n";
print CFG "url=$url\n";
close(CFG);

print "\n".$MSG_DONE;
print $MSG_PATHS;
print "  Config file:\t$cfile\n";
print "  Pid file:\t$pidfile\n";
print "  Log file:\t$logfile\n";
print "  Cache file:\t$cachefile\n";
print "\n".$MSG_END;

exit 0;

sub ask_value
{
  my $msg = shift;
  my $default = shift || undef;
  my $invalue="";
  while( $invalue eq "" )
  {
    print $msg;
    chop ( $invalue=<STDIN> );
    $invalue = $default if ( defined $default && $invalue eq "" );
  }
  return $invalue;
}

sub make_select
{
  my ($arrayRef, $selTitle, $multiselect)=(@_);
  $multiselect = 1 unless defined $multiselect;
  my @items= @$arrayRef;
  SLSTART:
  print $selTitle;
  my $i=0;
  foreach my $item (@items)
  {
    print "  " . $i++."\t$item\n";
  }
  print "[separate multi selects by space]\n" if $multiselect;
  print "Your selection: ";
  my $line=<STDIN>;
  chop $line;
  $line =~ s/^\s+|\s+$//g ;
  goto SLSTART if($line eq "");
  my @tofilter=split(/\s+/, $line);
  my @select;
  foreach my $fil (@tofilter)
  {
    goto SLSTART if( ! ( $fil =~ /^\d+$/ ) );
    $fil =~ s/\s+//g;
    next if $fil eq "";
    if($items[$fil]) {
      $items[$fil] =~ s/^\s+|\s+$//g ;
      push @select, $items[$fil];
    }
  }
  if( ! $multiselect && scalar( @select ) > 1)
  {
    print "Please select one only !!\n";
    goto SLSTART;
  }
  goto SLSTART if(!@select);
  return ( @select ) if $multiselect;;
  return $select[0];
}

sub confirm
{
  my ($answerYes, $answerNo, $question, $title) = ( @_ );
  my $answer="";
  print $title;
  do
  {
    print $question;
    $answer=<STDIN>;
    if ( $answer eq "\n" )
    {
      $answer="yes";
    }
    else
    {
      $answer=lc($answer);
      if((my $chr=chop($answer)) ne "\n"){
        $answer.=$chr;
      }
    }
  } until $answer eq 'yes' || $answer eq 'no';
  return $answer;
}

sub set_autostart
{
  my $dir="@_";
  my $prodir=programdir();
  my $proname="ipUpdate.pl";
  if ( index( $dir, $prodir ) < 0 )
  {
    my $cmd=qq^cp -f $prodir/$proname $dir/. ; cp -f $prodir/Http_get.pm $dir/.; chmod a+x $dir/$proname^;
    print "$proname installed to $dir\n";
    system( $cmd );
  }
  #my $cmd = qq^( echo "\@reboot $dir/$proname"; crontab -l | grep -v "^\@reboot\s.+$proname") | crontab -^;
  my $cmd = qq^( echo "\@reboot $dir/$proname"; crontab -l | grep -v "\/$proname") | crontab -^;
  system($cmd);
  print "\"\@reboot $dir/$proname\" inserted to crontab\n";
}

sub programdir
{
  my $self = shift;
  my $PRODIR      =`dirname $0`;
  chop $PRODIR;
  if ( $PRODIR eq "." )
  {
    $PRODIR = `pwd`;
    chop $PRODIR;
  }
  return $PRODIR;
}
