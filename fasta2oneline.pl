#!/usr/bin/perl
use strict;
use warnings;

=head1 AUTHOR 
Tim A. Dahlmann
tim.dahlmann@rub.de
Chair of general and molecular botany
Ruhr-University Bochum
44801 Bochum, Germany

=head2 DISCRIPTION
Reads in a multiple fasta file containing nucleotide or amino acids sequences 
and prints out a multiple fasta file in oneline format. 

=head3 USAGE
perl fasta2oneline.pl <-h> <input.fa>

The output file is named  <input>_oneline.fa
Alternatively use the hardcoded option by changing the scalar $inputfile in line 38 or print help by using the -h argument.

=head4 VERSION
version 2.0
04.02.2014

=head5 COPYRIGHT (C)
The program fasta2oneline.pl is free software: you can redistribute it and/or modify it under the terms of the 
GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or 
(at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
See the GNU General Public License for more details (http://www.gnu.org/licenses/).

=cut

##### hardcoded option #####

my $inputfile = "chrV.fa";	# hardcoded input file, if you don't want to use the shell just enter the file name here

############################


my $input=$ARGV[0];
my $num_args = $#ARGV + 1;

# check the arguments and offer a -h help text
if ($num_args == 0) {	# if you prefere a hardcoded version just change the name of you input file
	print "You have chosen the hardcoded version of fasta2oneline.pl\nwith \"$inputfile\" as you input file.\nAlternatively use: fasta2oneline.pl input.fa\n";
 }

if ($num_args == 1) {
	if ($input eq "-h") {
		print "You entered -h for help:\nYou can choose between using a hardocded version by leaving out any arguments\nor by specifying your file name as an argument using a shell command.\nIt's you choice.\nUsage of the shell command: fasta2oneline.pl input.fa\n";
		exit;
	}
	else { $inputfile = $input;
	}
}
 
if ($num_args > 1) {
  print "\nUsage: fasta2oneline.pl input.fa\n or hardcoded\n";
  exit;
}

my $name;	# get the name of the input file without the .fa extension, this is needed to name the output file
if ($inputfile =~ /([a-zA-Z0-9_\-\+]+)\.\S+/) {
	$name = $1;
}
my $outfile = "$name\_oneline.fa";


open FASTAFILE, "< $inputfile" or die "$inputfile not found: $!";	# opens your input file
my @daten = <FASTAFILE>;	# pushes your data into an array

my @oneline;	# opens a new array for the oneline fasta sequences

foreach (@daten) {
	if ($_ =~ />/) {	# searching for the IDs
		push (@oneline, "\n");	# ID is seperated from the sequences
		push (@oneline, "$_");	# pushes the ID line into the array	
	}
	else { chomp ($_);	# chomp the newlines to get online formated fasta
		push (@oneline, $_);	# pushes the sequences to the array
	}
}
shift (@oneline);	# deletes the newline in line 1
push (@oneline, "\n"); # adds a newline to the end of the array

close FASTAFILE;													

open ONELINE, "> $outfile";
print ONELINE @oneline;
#print "@oneline";
close ONELINE;

exit;