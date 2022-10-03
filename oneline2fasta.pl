#!/usr/bin/perl
#use strict;
use warnings;

=head1 AUTHOR 
Tim A. Dahlmann
tim.dahlmann@rub.de
Chair of general and molecular botany
Ruhr-University Bochum
44801 Bochum, Germany

=head2 DISCRIPTION
Converts a oneline formated fasta file to an ordinary 60 nt seperated fasta file.

=head3 USAGE
perl oneline2fasta.pl <input_oneline.fa> <output.fa>

=head4 VERSION
version 1.1
07.07.2015

=cut

##### hardcoded option #####

my $oneline= "chrV_oneline.fa";	# hardcoded input file, if you don't want to use the shell just enter the file name here

############################


my $input=$ARGV[0];
my $num_args = $#ARGV + 1;

# check the arguments and offer a -h help text
if ($num_args == 0) {	# if you prefere a hardcoded version just change the name of you input file
	print "You have chosen the hardcoded version of fasta2oneline.pl\nwith \"$oneline\" as you input file.\nAlternatively use: fasta2oneline.pl input.fa\n";
 }

if ($num_args == 1) {
	if ($input eq "-h") {
		print "You entered -h for help:\nYou can choose between using a hardocded version by leaving out any arguments\nor by specifying your file name as an argument using a shell command.\nIt's you choice.\nUsage of the shell command: fasta2oneline.pl input.fa\n";
		exit;
	}
	else { $oneline = $input;
	}
}
 
if ($num_args > 1) {
  print "\nUsage: fasta2oneline.pl input.fa\n or hardcoded\n";
  exit;
}

my $name;	# get the name of the input file without the .fa extension, this is needed to name the output file
if ($oneline =~ /([a-zA-Z0-9_\-\+]+)_\S+\.\S+/) {
	$name = $1;
}
my $outfile = "$name.fasta";

##################################################

open INPUT, "< $oneline" or die "$oneline not found: $!";	# opens your input file
#my @daten = <INPUT>;	# pushes your data into an array

##################################################

my @fasta;

while (my $elem = <INPUT>) {
	if ($elem =~ /^>/i){				# push the ID into the array
		push (@fasta, $elem);
	}
	if ($elem =~ /^[A-Z]/i){			# find the nucleotide string 
		$elem =~ s/(.{80})/$1\n/gs;	# and split it after every 60 nt to obtain the standard fasta format
		$elem =~ s/\n\n/\n/gs;
		push (@fasta, $elem);		# push the splited nucleotide string into the array
		 
	}
}


open OUTPUT, "> $outfile";
#print @fasta;			# print the new format on screen
print OUTPUT @fasta;	# print the array into the output file


close INPUT;
close OUTPUT;

exit;
