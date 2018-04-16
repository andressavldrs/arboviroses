#############################################################################
#                                                                       	#
#  This program  uses a fasta file, ids and cds length (output of XMLparser)#
#  to generate a output with the sequence 3'UTR region only.		       	#
#  INPUT: get_3UTR.pl sequence.fa output_xml.txt                         	#
#  OUTPUT: virus_3UTR.fa 							                      	#
#                                                                       	#
#############################################################################
#!/usr/bin/perl

use strict;
use warnings;

sub read_file{
	my @lines = @_;
	my %mirnas;
	foreach my $line (@lines){
		if($line =~ m/(\S+)\s(\d+)\s(\d+)/ && ($3 >= 10)){
			$mirnas{$1} = "$2\t$3";
		}
	}
	return %mirnas;
}

if (@ARGV == 4 ) 
{
	my ($f_denv1, $f_denv2, $f_denv3, $f_denv4) = @ARGV;
	#my $utr_size = 0, my $x = 0, my $y = 0;


	#my %denv1, my %denv2, my %denv3, my %denv4; #hash: id => total_length
	

	open (my $f1, '<', $f_denv1)	or die "Can't open input file \"$f_denv1\": $!\n"; #sequence.fa file
	my %denv1 = read_file(<$f1>);
	close ($f1);
	
	open (my $f2, '<', $f_denv2)	or die "Can't open input file \"$f_denv2\": $!\n"; #sequence.fa file
	my %denv2 = read_file(<$f2>);
	close ($f2);
	
	open (my $f3, '<', $f_denv3)	or die "Can't open input file \"$f_denv3\": $!\n"; #sequence.fa file
	my %denv3 = read_file(<$f3>);
	close ($f3);
	
	open (my $f4, '<', $f_denv4)	or die "Can't open input file \"$f_denv4\": $!\n"; #sequence.fa file
	my %denv4 = read_file(<$f4>);
	close ($f4);
	

	foreach my $key (sort keys %denv1){
		if (exists($denv2{$key}) && exists($denv3{$key}) && exists($denv4{$key})){
			print "$key\t$denv1{$key}\t$denv2{$key}\t$denv3{$key}\t$denv4{$key}\n";	
		}
		elsif (!exists($denv2{$key}) && exists($denv3{$key}) && exists($denv4{$key})){
			print "$key\t$denv1{$key}\t0\t0\t$denv3{$key}\t$denv4{$key}\n";	
		}
		elsif (exists($denv2{$key}) && !exists($denv3{$key}) && exists($denv4{$key})){
			print "$key\t$denv1{$key}\t$denv2{$key}\t0\t0\t$denv4{$key}\n";	
		}
		elsif (exists($denv2{$key}) && exists($denv3{$key}) && !exists($denv4{$key})){
			print "$key\t$denv1{$key}\t$denv2{$key}\t$denv3{$key}\t0\t0\n";	
		}
		elsif (!exists($denv2{$key}) && !exists($denv3{$key}) && exists($denv4{$key})){
			print "$key\t$denv1{$key}\t0\t0\t0\t0\t$denv4{$key}\n";	
		}
		elsif (exists($denv2{$key}) && !exists($denv3{$key}) && !exists($denv4{$key})){
			print "$key\t$denv1{$key}\t$denv2{$key}\t0\t0\t0\t0\n";	
		}
		elsif (!exists($denv2{$key}) && exists($denv3{$key}) && !exists($denv4{$key})){
			print "$key\t$denv1{$key}\t0\t0\t$denv3{$key}\t0\t0\n";	
		}
		else{
			print "$key\t$denv1{$key}\t0\t0\t0\t0\t0\t0\n";	
		}

	}	

	foreach my $key (sort keys %denv2){
		if (!exists($denv1{$key}) && exists($denv3{$key}) && exists($denv4{$key})){
			print "$key\t0\t0\t$denv2{$key}\t$denv3{$key}\t$denv4{$key}\n";	
		}
		elsif (!exists($denv1{$key}) && !exists($denv3{$key}) && exists($denv4{$key})){
			print "$key\t0\t0\t$denv2{$key}\t0\t0\t$denv4{$key}\n";	
		}
		elsif (!exists($denv1{$key}) && !exists($denv3{$key}) && exists($denv4{$key})){
			print "$key\t0\t0\t$denv2{$key}\t$denv3{$key}\t0\t0\n";	
		}
		elsif (!exists($denv1{$key})){
			print "$key\t0\t0\t$denv2{$key}\t0\t0\t0\t0\n";	
		}
	}

	foreach my $key (sort keys %denv3){
		if (!exists($denv1{$key}) && !exists($denv2{$key}) && exists($denv4{$key})){
			print "$key\t0\t0\t0\t0\t$denv3{$key}\t$denv4{$key}\n";	
		}
		elsif (!exists($denv1{$key}) && !exists($denv2{$key}) && !exists($denv4{$key})){
			print "$key\t0\t0\t0\t0\t$denv3{$key}\t0\t0\n";	
		}
	}

	foreach my $key (sort keys %denv4){
		if (!exists($denv1{$key}) && !exists($denv2{$key}) && !exists($denv3{$key})){
			print "$key\t0\t0\t0\t0\t0\t0\t$denv4{$key}\n";	
		}
	}

}
else 
{
	print "Error: Missing arguments!";
}
