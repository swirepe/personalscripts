#!/usr/bin/env perl

# http://www.perl.com/pub/2002/10/01/hashes.html
# Return the hashed value of a string: $hash = perlhash("key")
# (Defined by the PERL_HASH macro in hv.h)
sub perlhash
{
		$hash = 0;
		foreach (split //, shift) {
				$hash = $hash*33 + ord($_);
		}
		return $hash;
}


$host =  `hostname`;
$hash = perlhash($host);

$fg_color = ($hash % 200) + 1;
print "colour$fg_color"
