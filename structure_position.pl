#!/usr/bin/perl -I.libs
###
# Give a position the program finds for each sequence the correspond
# in the structure and compares with consensus
# perl structure_position.pl clustalw.aln refold.out
###

use strict;

use Data::Dumper;
use FileHandle;

use RNA;
use warnings;

if (@ARGV == 2 ) 
{ 
	my ($f_refold, $f_miranda) = @ARGV;
	#my $aligments = read_clustal();
	open (my $fh_refold, '<', $f_refold)	#output from miranda
		or die "Can't open input file \"$f_refold\": $!\n";  
	open (my $fh_miranda, '<', $f_miranda)	#output from miranda
		or die "Can't open input file \"$f_miranda\": $!\n"; 

	my $structures = read_refold($fh_refold);
	my %predicted_targets = read_miranda($f_miranda);
	
	#my $consensus = read_rnaz();

	foreach my $mirna (sort keys %predicted_targets) {
		print "microRNA: $mirna\n";
		foreach my $positions (keys %{$predicted_targets{$mirna}}) {
			#print "position: $positions\n\t CODs: @{$targets{$mirna}{$positions}}\n\n";
			print "\tposition: $positions\n";
			my ($ini, $end) = split(/\s/, $positions);
			find_position($structures, $ini, $end, @{$predicted_targets{$mirna}{$positions}});
		}
	}

	#find_position($structures, 30, 50);
	close($fh_refold);
	close($fh_miranda);

}
else{

	print "Usage: perl structure_position.pl refold.out miranda.out\n";

}

# ---------------------------------------------------------------------

# reads refold.pl outrefoldput with all sequences folded individually and 
# without gaps
sub read_refold{
	my ($fh) = @_;
	my @out=();
	my (%order, $order, %structures, $seqname);
	while(my $line = <$fh>) {
		next if ($line =~ m/^[ATGCU]+/ );
		my $struct;
		if($line =~ m/^>\s(\S+)/ ) {
			$seqname = $1;
		} elsif($line =~ m/^([.()]+)/ ) {
			$struct = $1;
			#$structures{$seqname} = $struct;
			$structures{$seqname} = RNA::db_to_element_string($struct);
		} else {
			next;
		}
	}

	foreach my $name ( keys %structures ) {
		#print "$name -> $structures{$name}\n";
		 my $struct=$structures{$name};
		 push @out, {name=>$name,struct=>$struct};
	}
  return [@out];
}

# Gives a certain position (min-max), returns the correspond structure 
sub find_position {
	my ($structures, $ini, $end, @names) = @_;
	my %targets;
	my $length = $end - $ini;
	# Miranda considers 1 the first position and 
	# perl considers 0 the firt position
	foreach my $a (@$structures){
		if (grep(/^$a->{name}$/, @names)){
			#print "> $a->{name}\n $a->{struct}\n";
			my $target = substr($a->{struct}, $ini+1, $length);
			#print "alvo: $target\n";
			# Count the occurences of this target   
			push(@{$targets{$target}}, $a->{name});
		}
		
	}

	foreach my $key ( keys %targets ) {
		# Verify if key is a possible candidate by structural features
		if (substr($key, -8, 7) =~ m/[a-z]{4}/){
			print "\t>Target: $key\tOccurrences:" ;
			print scalar @{$targets{$key}};
			print "\n";	
		}
		else{
			print "\t Target: $key\tOccurrences:" ;
			print scalar @{$targets{$key}};
			print "\n";		
		}
		
	}
}


#Parse miranda output file
sub read_miranda{
	my ($filename) = @_;
	my %targets;
	open (my $file, '<', $filename)	#output from miranda
		or die "Can't open input file \"$filename\": $!\n";  
	
	#my @out, %targets;
	while (my $line = <$file>) {
		#>cel-miR-80-5p  KT187562        143.00  -21.96  2 20    27 48   18      66.67%  77.78%
		if( $line =~ m/^>(\S+)\s(\S+)\s\S+\s\S+\s\d+\s\d+\s(\d+\s\d+)\s\S+.\S+%\s(\S+)%/){
			#$targets{$miRNA}{positions}[cod names]
			push (@{$targets{$1}{$3}}, $2)
		}
	}

	# foreach my $mirna (sort keys %targets) {
	# 	print "microRNA: $mirna\n";
	# 	foreach my $positions (keys %{$targets{$mirna}}) {
	# 		print "position: $positions\n\t CODs: @{$targets{$mirna}{$positions}}\n\n";
	# 	}
	# }
	return %targets;
}

