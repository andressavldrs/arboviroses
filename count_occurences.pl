#!/usr/bin/perl 
###
# Count all occurrences and possible candidates
# from structure_position.pl output 
###

use strict;
use warnings;

my %targets, my %candidates, my $mirna;

while (<>) {
	if(/^microRNA:\s(\S+)$/){
		$mirna = $1;
	}#>Target: IIIiIIIIIIiIIiiiiii	Ocurrences:1
	elsif(/^\s>Target:\s\S+\sOccurrences:(\S+)$/){
		$candidates{$mirna} += $1; 
	}
	if(/Target:\s\S+\sOccurrences:(\S+)/){
		$targets{$mirna} += $1; 
	}
}

print "microRNA\tcandidatos\ttotal\n";
foreach my $key (keys %targets){
	#print "$key	$targets{$key}\n";
	print exists($candidates{$key}) ? "$key\t$candidates{$key}\t$targets{$key}\n" : "$key\t0\t$targets{$key}\n";  	
	
}
