package Module::CPANTS::Maypole;
use strict;
use warnings;
use Cwd qw(cwd);

our $VERSION = '0.02';

use base 'CGI::Maypole';
BEGIN {
	Module::CPANTS::Maypole->setup("dbi:SQLite:dbname=../../db/cpants.db");
}
Module::CPANTS::Maypole->config->{rows_per_page} = 10;

Module::CPANTS::Maypole::Cpan->has_a(cpanid => "Module::CPANTS::Maypole::Authors");
Module::CPANTS::Maypole::Authors->has_many(cpans => "Module::CPANTS::Maypole::Cpan");

Module::CPANTS::Maypole::Prereq->has_a(dist => "Module::CPANTS::Maypole::Distribution");
Module::CPANTS::Maypole::Distribution->has_many(prerequisites => "Module::CPANTS::Maypole::Prereq");

#Module::CPANTS::Maypole::Cpan->has_a(dist => "Module::CPANTS::Maypole::Distribution");
#Module::CPANTS::Maypole::Distribution->has_a(dist => "Module::CPANTS::Maypole::Cpan");


sub authenticate {
	my ($self, $r) = @_;
	
#	if ($r->{table} eq "prereq") {
#		$r->template("error");
#		$r->{template_args}{error_message} = "Unfortunately we cannot currently display the Prereq table";
#	}
	
	if ($r->action !~ /^(list|view|search)$/) {
		$r->template("error");
		$r->{template_args}{error_message} = "This is a read-only database. 
		If you really want to change the ratings of your module, go write some more tests and documentation.";
	}

	return 0;
}


sub get_template_root { 
	my $pwd = cwd;
	return "$pwd/../templates";
}

=head1 TITLE

Module::CPANTS::Maypole - Web interface to the CPANTS database using Maypole

=head1 Description

 The database schema used now is not fully supported by SQL::Parser hence we had to
 changed the schema a bit. This is being done in the db/clean.pl script.

 Besides this code is being reliesed mainly so that other people can look at it commend on
 it and send patches.

=head1 Author

 Module::CPANTS is being developed by Thomas Klausner

 This front end was written by Gabor Szabo


=cut

1;

