package Module::CPANTS::Maypole;
use strict;
use warnings;
use Cwd qw(cwd);

our $VERSION = '0.05';

use base 'CGI::Maypole';
#BEGIN {
	Module::CPANTS::Maypole->setup("dbi:SQLite:dbname=../../db/cpants.db");
#}
Module::CPANTS::Maypole->config->{rows_per_page} = 10;
Module::CPANTS::Maypole->config->{uri_base} = "http://$ENV{HTTP_HOST}/";  # I need this for the search buttons..
#push @{Module::CPANTS::Maypole->config->{classes}}, "Module::CPANTS::Maypole::Stats";
#push @{Module::CPANTS::Maypole->config->{tables}}, "stats";
#$Module::CPANTS::Maypole->{config}->{loader}->{CLASSES}->{stats} = "Module::CPANTS::Maypole::Stats";
use Data::Dumper;
my $h = Module::CPANTS::Maypole->config;
#warn $h;
#warn Dumper $h;

Module::CPANTS::Maypole::Dist->has_a(author => "Module::CPANTS::Maypole::Authors");
Module::CPANTS::Maypole::Authors->has_many(distributions => "Module::CPANTS::Maypole::Dist");

Module::CPANTS::Maypole::Kwalitee->has_a(distid => "Module::CPANTS::Maypole::Dist");
Module::CPANTS::Maypole::Prereq->has_a(distid => "Module::CPANTS::Maypole::Dist");

Module::CPANTS::Maypole::ModulesInDist->has_a(distid => "Module::CPANTS::Maypole::Dist");
Module::CPANTS::Maypole::Dist->has_a(modules => "Module::CPANTS::Maypole::ModulesInDist");

Module::CPANTS::Maypole::Authors->require;
Module::CPANTS::Maypole::Stats->require;

#warn "loaded";

sub authenticate {
	my ($self, $r) = @_;
	
	#warn $r->action;
	if ($r->action !~ /^(list|view|search|all|show)$/) {
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

=head1 NAME

Module::CPANTS::Maypole - Web interface to the CPANTS database using Maypole

=head1 Description

 The database schema used now is not fully supported by SQL::Parser hence we had to
 changed the schema a bit. This is being done in the db/clean.pl script.

 To access the database visit L<http://cpants.szabgab.com/>
 
 This code is being released to CPAN mainly so that other people can look at it, 
 comment on it and send patches.
 

=head1 Author

 Module::CPANTS is being developed by Thomas Klausner L<http://cpants.dev.zsi.at/>

 This front end was written by Gabor Szabo L<http://www.szabgab.com/>

=cut

1;

