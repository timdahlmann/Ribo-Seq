#!/usr/bin/perl
use strict;
use warnings;

use Array::Utils qw(:all);
use Venn::Chart;

=head1 AUTHOR 
Dr. Tim A. Dahlmann
@: tim.dahlmann@rub.de
Chair of general and molecular botany
Ruhr-University Bochum
44801 Bochum, Germany

=head2 DISCRIPTION
Summerize the results of the the lists containing the ID (locus_tag, protein ID, etc.) of three independent experiments and calculates a Venn 
diagram. The IDs of the found entries, read in als three .txt. lists wil be compared to identify sets of intersection and unique IDs between 
the three experiments, using the Array::Utils and Venn:Chart perl modules. Furthermore, Venn diagrams, histo plots, and a list of the 
corresponding IDs will be printed out to the workingfolder.

=head3 USAGE
perl summarize_to_Venn.pl

=head4 VERSION
version 3.0
(hardcoded version)
28.05.2021

=head5 COPYRIGHT
Copyright (C) 2021 Tim A. Dahlmann
The program 
summarize_to_Venn.pl
is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License 
as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later 
version. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without 
even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
See the GNU General Public License for more details (http://www.gnu.org/licenses/).

=cut


### Input files of the data sheets ###


my $treat = "SRT";
#my $time = "_1h";
my $direct = "_down";

my $input1 = "ribo_$treat\_vs_DMSO_4h$direct";
my $input2 = "mRNA_$treat\_vs_DMSO_4h$direct";
#my $input3 = "$treat\_4h$direct";

#my $input1 = "SRT$time$direct";
#my $input2 = "FLC$time$direct";
#my $input3 = "SF$time$direct";


my $outputfile = "VennList_$treat$direct.txt";
open OUTPUT, "> $outputfile"; # Öffnen der Outputfile


####

	open INPUT1, "< $input1.txt" or die {"Can't open inputfile!\n"}; # Open inputfile
	my @data1;
	chomp (@data1 = <INPUT1>);	# Delete all newlines at the end of each row
	
	open INPUT2, "< $input2.txt" or die {"Can't open inputfile!\n"}; # Open inputfile
	my @data2;
	chomp (@data2 = <INPUT2>);	# Delete all newlines at the end of each row
	
#	open INPUT3, "< $input3.txt" or die {"Can't open inputfile!\n"}; # Open inputfile
#	my @data3;
#	chomp (@data3 = <INPUT3>);	# Delete all newlines at the end of each row


####################
### Venn diagram
### Create a Venn diagram with the module use Venn::Chart

# Venn diagram for the experiment
# Create the Venn::Chart constructor
my $venn_chart = Venn::Chart->new( 400, 400 ) or die("error : $!");

# Set a title and a legend for our chart
$venn_chart->set_options( -title => 'Venn diagram' );
$venn_chart->set_legends( $input1, $input2);#, $input3 );

# Create a diagram with gd object
my $gd_venn = $venn_chart->plot( \@data1, \@data2);# \@data3 );

# Create a Venn diagram image in png, gif or jpeg format
open my $fh_venn, '>', "VennChart_$treat$direct.png" or die("Unable to create png file\n");
binmode $fh_venn;
print {$fh_venn} $gd_venn->png;
close $fh_venn or die('Unable to close file');

# Create an histogram image of Venn diagram (png, gif or jpeg format)
my $gd_histogram = $venn_chart->plot_histogram;
open my $fh_histo, '>', "VennHistogram_$treat$direct.png" or die("Unable to create png file\n");
binmode $fh_histo;
print {$fh_histo} $gd_histogram->png;
close $fh_histo or die('Unable to close file');

# Get data list for each seven intersections/unique regions between the 3 lists
my @ref_lists = $venn_chart->get_list_regions();
my $list_number = 1;
foreach my $ref_region ( @ref_lists ) {
  #print "List $list_number : @{ $ref_region }\n";
  print OUTPUT "List $list_number: @{ $ref_region }\n";
  $list_number++;
}

close INPUT1;
close INPUT2;
#close INPUT3;
close OUTPUT;
