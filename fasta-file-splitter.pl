#!/usr/bin/perl
use strict;

my $f_in   = $ARGV[0];
my $pieces = $ARGV[1];
die "Usage: ./split_file.pl <file> <pieces>\n" 
     unless ( length($f_in) && length($pieces) );

die "can't find input file $f_in\n" unless (-e $f_in);

# Break up input into temp files

open(F,$f_in) or die "can't open $f_in $!\n";
my $file_contents = join('', <F>);
close F;

my @lines = split(/\>/,$file_contents);
shift @lines;
my $lines_per_piece = int(scalar(@lines) / $pieces);

print STDERR scalar(@lines)." lines in $f_in, split into $pieces pieces of size $lines_per_piece\n";

# Create input files
my $file_name;
foreach (1..$pieces) {
	$file_name = $_.".dat";
	die "filename: $file_name exists!! split_file.pl is exiting\n" unless (! -e $file_name);
	print STDERR "write $file_name at ".localtime()."\n";
	open (TMPFILE, ">$file_name");
		foreach (1..$lines_per_piece) { 		
			print TMPFILE ">".(shift @lines);
		}
	close(TMPFILE);
}

# Append remaining lines into the last tmp file
my $lines_left = scalar(@lines);
print STDERR "appending $lines_left to $file_name at ".localtime()."\n";
open (TMPFILE, ">>$file_name");
	foreach (@lines){
		print TMPFILE ">".$_;
	}
close(TMPFILE);
