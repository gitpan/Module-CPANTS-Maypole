#!/usr/bin/perl
use strict;
use warnings;

# in order to use thisyou might need to change some values that
# are specific to my system such as the name of the sqlite-... program.


system "echo .dump | sqlite-2.8.14.bin cpants.db_original > dump.data";
print "In this version I did some manual cleaning\n";
print "If you'd like to setup your own version you'll have to do it yourself too :-)\n";
exit;


open IN, "dump.data";
open OUT, ">changed.data";
my $create;
my $prereq = 1;
my $modules = 1;
while (<IN>) {

	# removing some fancy database stuff that SQL::Parser cannot handle
	# a missing primary key   entry
	s/default 0//;           # still here
	s/ unsigned//;           # still here
	s/ float/ varchar(20)/;  # still here
	s/ int\s/ integer/;      # still here
#	s/ bigint/ integer/;       
#	s/ tinyint/ integer/;
#	s/date date/date varchar(30)/;
#	s/not null//;
	next if /^INSERT INTO authors VALUES\(NULL,NULL,NULL,0,0\);/;


	if ($create) {
		#if ($create eq "prereq") {
		#	print OUT "  id integer primary key,\n",
		#} elsif ($create eq "modules") {
		#	print OUT "  id integer primary key,\n",
		#} else {
			s/,/ primary key,/; # set the first column of every table except the above 2 
		}
	}
	$create = '' if $create; # reset so we do it only once
	if (/^create table (\w+)/) {
		$create = $1;
	}


	if (s/^(INSERT INTO prereq VALUES\()/$1$prereq,/) {
		$prereq++;
	}
	if (s/^(INSERT INTO modules VALUES\()/$1$modules,/) {
		$modules++;
	}

	s/(INSERT INTO authors VALUES\('[^']*','[^']*',')[^']+/$1/;

#	next if /^INSERT/;
	print OUT $_;
}
close IN;
close OUT;

unlink "cpants.db";
#system "sqlite-2.8.14.bin cpants.db < changed.data";
