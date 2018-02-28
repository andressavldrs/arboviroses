#!/usr/bin/perl -I.libs
###
# Give a position the program finds for each sequence the correspond
# position in the structure and compares with consensus
###

use strict;

use Data::Dumper;
use FileHandle;

use RNA;
use warnings;

my %gaps;
my $aligments = read_clustal();
my $structures = read_refold();


foreach my $a (@$aligments){
	print "> $a->{name}\n $a->{seq}\n";
}

find_position($structures, 30, 50);

# reads refold.pl outrefoldput with all sequences folded individually and 
# without gaps
sub read_refold{
	my @out=();
	my (%order, $order, %structures, $seqname);
	while(<>) {
		next if ( m/^[ATGCU]+/ );
		#print "$line";
		my $struct;
		if(m/^>\s(\S+)/ ) {
			$seqname = $1;
		} elsif(m/^([.()]+)/ ) {
			$struct = $1;
			$structures{$seqname} = $struct;
			#$structures{$seqname} = RNA::vrna_db_to_element_string($struct);
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

# reads file of the alignment in ClustalW format (from refold.pl)
sub read_clustal{
#  my $fh=shift;
  my @out=();
  my (%order, $order, %alignments);
  while(<>) {
        last if eof;
        next if ( /^\s+$/ );
        my ($seqname, $aln_line) = ('', '');
        if( /^\s*(\S+)\s*\/\s*(\d+)-(\d+)\s+(\S+)\s*$/ ) {
          # clustal 1.4 format
          ($seqname,$aln_line) = ("$1/$2-$3",$4);
        } elsif( /^(\S+)\s+([A-Z\-]+)\s*$/ ) {
          ($seqname,$aln_line) = ($1,$2);
        } else {
          next;
  }
        if( !exists $order{$seqname} ) {
          $order{$seqname} = $order++;
        }
        $alignments{$seqname} .= $aln_line;
  }

  foreach my $name ( sort { $order{$a} <=> $order{$b} } keys %alignments ) {
        if( $name =~ /(\S+):(\d+)-(\d+)/ ) {
          (my $sname,my $start, my $end) = ($1,$2,$3);
        } else {
          (my $sname, my $start) = ($name,1);
          my $str  = $alignments{$name};
          $str =~ s/[^A-Za-z]//g;
          my $end = length($str);
        }
        my $seq=$alignments{$name};
        push @out, {name=>$name,seq=>$seq};
  }
  return [@out];
}
# Gives a certain position (min-max), returns the correspond structure 
sub find_position {
	my ($structures, $ini, $end) = @_;
	my $length = $end - $ini;
	my %targets;
	foreach my $a (@$structures){
		print "> $a->{name}\n $a->{struct}\n";
		my $target = substr($a->{struct}, $ini, $length);
		#print "alvo: $target\n";
		# Count the occurences of this target   
		$targets{$target}++;
		
	}

	foreach my $key ( keys %targets ) {
		print "Target: $key	Ocurrences: $targets{$key}\n";
	}
}

# Counts gaps positions of each sequence 
sub count_gaps{
	
}

# Compares structures with consensus sequence considerating gaps 
sub compare_consensus{

}