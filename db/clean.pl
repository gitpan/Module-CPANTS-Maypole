#!/usr/bin/perl
use strict;
use warnings;

system "echo .dump | sqlite-2.8.14.bin cpants.db > dump.data";
open IN, "dump.data";
open OUT, ">changed.data";
my $create;
my $prereq = 1;
while (<IN>) {

	# removing some fancy database stuff that SQL::Parser cannot handle
	s/default 0//;
	s/unsigned//;
	s/ float/ varchar(20)/;
	s/ int\s/ integer/;
	s/bigint/integer/;
	s/tinyint/integer/;
	s/date date/date varchar(30)/;


	if ($create) {
		if ($create eq "prereq") {
			print OUT "  id integer primary key,\n",
		} else {
			s/,/ primary key,/;
		}
	}
	$create = '' if $create; # reset so we do it only once
	if (/^create table (\w+)/) {
		$create = $1;
	}


	if (s/^(INSERT INTO prereq VALUES\()/$1$prereq,/) {
		$prereq++;
	}

	s/(INSERT INTO authors VALUES\('[^']*','[^']*',')[^']+/$1/;

#	next if /^INSERT/;
	print OUT $_;
}
close IN;
close OUT;

unlink "cpants.db";
system "sqlite-2.8.14.bin cpants.db < changed.data";

# set the first column of every table to be the   "primary key"
#
