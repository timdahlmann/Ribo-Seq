#!/usr/bin/perl
use strict;
use warnings;

=head1 AUTHOR 
Tim A. Dahlmann
tim.dahlmann@rub.de
Chair of general and molecular botany
Ruhr-University Bochum
44801 Bochum, Germany

=head2 VERSION
Verion #2 from 05.02.2021
Previous script: "clonality.pl"

=head3 DISCRIPTION
Reads a multi-fasta file and calculates the number of reads that contains clonality information within the header _x(\d*).
The output-file contains the calculation in this type: "clonality" \t "readcount".

=head4 USAGE
perl clonality.pl #this perl script uses a hardcoded input: 24 files 4-96-$id\_26-34nt_collapsed.fasta with $id ranging from 1 to 24.

=cut

# Placeholder for softcoded input and output files

# check if we have the correct number of arguments
#my $num_args = $#ARGV + 1;
#if ($num_args != 2) {
#  print "\nUsage: perl read-length.pl inputfile.fasta outputfile.txt";
#  exit;
#}

#my $inputfile=$ARGV[0]; # <= Inputfile
#my $outputfile=$ARGV[1]; # <= Outputfile


for (my $id=1; $id <= 24; $id++) {	# Run loop for all 24 files
       
	my $inputfile = "4-96-$id\_26-34nt_collapsed.fasta";	# <= Inputfile
	my $outputfile = "4-96-$id\_output.txt";			# <= Outputfile

	open INPUT, "< $inputfile" or die {"Can't open inputfile!\n"}; # Open inputfile
	open OUTPUT, "> $outputfile"; # Open outputfile

	my @daten;
	chomp (@daten = <INPUT>);	# Delete all newlines at the end of each row

	my $whole_seq = 0;	# Define all strict variables
	my $seq_laenge;
	my %hashall;
	my %hashcount;
	my $counter;
	my $countall = 0;
	my $countunique = 0;
	my $countx = 0;
	my $countx5 = 0;
	my $max = 1;

	# Check if a fasta or fastq file is provided as input
	
	#if ($daten[0] =~ /^>/) {
	#	print "The input files contains fasta sequences!\n";
	#	}
	#if ($daten[0] =~ /^@/) {
	#	print "The input file contains fastq sequences!\n";	
	#	}

	foreach (@daten) {		# Use a loop to define the maximal value of \d+ that can be used a top border for the upcomming loop
		if ($_ =~ /_x(\d*)$/){
			if ($1 > $max) { $max = $1};
		}	
	}
		
	for (my $i=1; $i <= $max; $i++) {	# $max is the afore calculated maximal clonality
		$hashcount{"$i"} =0;			# Create a %hash filled with zeros
	}

	foreach (@daten) {
		if ($_ =~ /_x(\d*)$/){
			$counter = $1;
			$countall = $countall + $counter;
			$countunique +=1;
			$hashcount{"$counter"} +=1;	# Write the number of reads to %hashcounter
			if ($counter > 1){
				$countx +=1;
			}
			if ($counter > 5){
				$countx5 +=1;
			}
		}
		if ($_ =~ /^[ATGCNRYSWKM]+$/) {	# Identifies the nucleotide sequence
			my $seq = $_;
			$whole_seq += length($_);
			$seq_laenge = length($_);	# Get the sequence length of all sequences
			$hashall{"$seq_laenge"} +=1;	# Write the sequence length to %hashall
		}	
	}

	print "\nNumber all reads in $inputfile:",$countall,"\n";
	print "Number all unique reads in $inputfile:",$countunique,"\n";
	print "Number of polyclonal reads in $inputfile:",$countx,"\n";
	print "Number of polyclonal reads in $inputfile with more than 5 copies:",$countx5,"\n";
	print "Clonality of reads: Number of copies (left), number of reads (right)\n";
	foreach $counter (sort {$a <=> $b } keys %hashcount) {	# Sort numerically ascending
		print "$counter\t$hashcount{$counter}\n";		# Print on screen
		print OUTPUT "$counter\t$hashcount{$counter}\n";	# Print to OUTPUT
	}

	close INPUT;
	close OUTPUT;
}