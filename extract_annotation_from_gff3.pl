#!/usr/bin/perl
use strict;
use warnings;

=head1 AUTHOR 
Tim A. Dahlmann
tim.dahlmann@rub.de
Chair of General and Molecular Botany
Ruhr-University Bochum

=head2 DISCRIPTION
The script gff2togff3.pl converts gff2 in gff3 format. For each entry inside the gff2 file it creates a gene entry and a corresponding features 

=head3 VERSION
version 1.0
03.06.2014

=head4 USAGE

=head5 COPYRIGHT (C)
The program fasta2oneline.pl is free software: you can redistribute it and/or modify it under the terms of the 
GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or 
(at your option) any later version. This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
See the GNU General Public License for more details (http://www.gnu.org/licenses/).

=cut

##### hardcoded option #####
my $inputfile = "H99_annotation_v2.gff3";	# hardcoded input file, if you don't want to use the shell just enter the file name here

##### softcoded option #####
my $input=$ARGV[0];
my $num_args = $#ARGV + 1;


# check the arguments and offer a -h help text
if ($num_args == 0) {	# if you prefere a hardcoded version just change the name of you input file
	print "\nYou have chosen the hardcoded version of gff2togff3.pl\nwith \"$inputfile\" as your input file.\nAlternatively use: gff2togff3.pl input.gff\n\n";
 }

if ($num_args == 1) {
	if ($input eq "-h") {
		print "\nYou entered -h for help:\nYou can choose between using a hardocded version by leaving out any arguments\nor by specifying your file name as an argument using a shell command.\nUsage: gff2togff3.pl input.gff\nIt's you choice.\n\n";
		exit;
	}
	else { $inputfile = $input;
	}
}
 
if ($num_args > 1) {
  print	"\nERROR: wrong number of arguments!\nUsage: gff2togff3.pl inputfile.gff or use hardcoded option\nType gff2togff3.pl -h for further details.\n\n";
  exit;
}

my $name;	# get the name of the input file without the .xxx file extension, this is needed to name the output file
if ($inputfile =~ /([a-zA-Z0-9_\-\+]+)\.\S+/) {
	$name = $1;
}

my $outfile = "$name.txt";
if ($num_args <= 1) {
	print "\nThe results are written into the file $outfile...\n\n";
}

############################

open INPUT, "< $inputfile" or die "Can't open $inputfile!";	# open inputfile or respond an error
my @gff_input = <INPUT>;

my $id;
my $annot;
my @daten;
my $counter=1;
push (@daten, "### Extracted annotation from gff file '$inputfile' \n");

foreach my $elem (@gff_input) { 
if (($elem =~ /\tmRNA\t/) and ($elem =~ /variant[ ;]/)) {
	}
	elsif (($elem =~ /\tmRNA\t.*locus_tag=(.{8,15});.*;product=([^;]*)/ )) {
		$id = $1;
		$annot = $2;
		push (@daten, "$1\t$2\n");
		}
	else{
		}
}
	

open OUTPUT, "> $outfile";	# open a fasta file for every scaffold
print OUTPUT @daten; # print it into the output file

close OUTPUT;
close INPUT;

exit;