DnsExit.com IpUpdate_d Perl Version 1.70 (Linux/Unix/FreeBSD/MacOS X/Arch Linux)

Follow these steps to update your host IP at dnsExit system:

1. Sign Up an account with dnsExit.com
2. Create your DNS records for your domain at dnsExit.com
3. Run setup.pl script and set your login name, password, and host(s) to update.
4. Run ipUpdate.pl to update your IP at dnsExit.com and save PID

SYSTEM RUQUIREMENTS: 
  Perl version 5 and newer.
  

TIPS & NOTES:

1. The program can be executed by command
  >> perl ipUpdate.pl
  >> ipUpdate.pl
  Log will be piped to /var/log/dnsexit.log

2. If choose auto start, the ipUPdate.pl will be added to crontab to start at
   boot up.

3. File "/tmp/dnsexit-ip.txt" will cache the ip address of the last successful IP 
   update to our system. For next update, if the IP stays the same, the update 
   request won't be sent to our server. You can simply change the IP at 
   dnsexit-ip.txt file to force the update to DNSEXIT.


BUG REPORTS
  Send all bug reports to support@dnsexit.com
