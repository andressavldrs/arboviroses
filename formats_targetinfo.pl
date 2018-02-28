#######################################################################
# This program format a mirna family info file to a target scan format#
#	INPUT: formats_targetinfo.pl miR_familyinfo.txt output.txt		  #	
#	OUTPUT: output.txt												  #	
#######################################################################

#!/usr/bin/perl -w
use strict;
# Edit miR_Family_Info.txt to target scan format
# Selects only 9606 (Homo sapiens)

if (@ARGV == 2 ) 
{
	my ($f_mirna, $f_output) = @ARGV;

	my %mir_ids; #hash: id => total_length
	
	open (my $in, '<', $f_mirna)	or die "Can't open input file \"$f_mirna\": $!\n"; #sequence.fa file
	open (my $out, '>', $f_output)	or die "Can't open input file \"$f_output\": $!\n";  #sequences w only 3utr region
	

	while (my $line = <$in>)	
	{
		if($line =~  m/(\S+)	(.*)	9606	.*/){ #miR family	Seed+m8	Species ID	.*			
			$mir_ids{$1} = $2;	
		}
	}

	foreach my $key (keys %mir_ids){
		print $out "$key	$mir_ids{$key}	9606\n";
	}

close($in);
close($out);

}
else 
{
	print "Error: Missing arguments!";
}
