use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
	module_name         => 'Module::CPANTS::Maypole',
	dist_version_from   => 'www/cgi/Module/CPANTS/Maypole.pm',
	license             => 'perl',
	dist_author         => 'Gabor Szabo <gabor@pti.co.il>',
	dist_abstract       => 'Web front-end to the CPANTS database using Maypole',
	create_makefile_pl  => 'traditional',
	create_readme       => 1,
	requires            => {
		'Maypole'                   => 0,
		'DBD::SQLite'               => 0,
	},
);

$builder->create_build_script();
