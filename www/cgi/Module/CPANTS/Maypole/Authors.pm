package Module::CPANTS::Maypole::Authors;

__PACKAGE__->set_sql('details', 
                       "SELECT distid, name, kwalitee 
					   FROM dist,kwalitee
					   WHERE dist.author==? and dist.id==kwalitee.distid");



sub view :Exported {
	my ($self, $r) = @_;

	#use Data::Dumper;
	#warn Dumper $r;
	my $path_info = $r->{cgi}->path_info;
	if ($path_info =~ m{/authors/view/(\w+)}) {
		$r->{template_args}{details} = [__PACKAGE__->search_details($1)];
	}
}




__PACKAGE__->set_sql('kwalitee_distribution',
					 "SELECT kwalitee,count(kwalitee) AS cnt 
					 FROM kwalitee 
					    GROUP BY kwalitee 
						ORDER BY kwalitee");


__PACKAGE__->set_sql('meta_yml',
                     "SELECT count(file_meta_yml) FROM dist WHERE file_meta_yml=1"); 

__PACKAGE__->set_sql('total',
                     "SELECT count(id) FROM dist"); 

__PACKAGE__->set_sql('meta_yml_2004',
                     "SELECT count(file_meta_yml) FROM dist WHERE file_meta_yml=1 and released_epoch > 1072915200"); 

__PACKAGE__->set_sql('total_2004',
                     "SELECT count(id) FROM dist WHERE  released_epoch > 1072915200"); 

__PACKAGE__->set_sql('make',
                     "SELECT count(id) FROM dist WHERE file_makefile_pl=1");
__PACKAGE__->set_sql('build',
                     "SELECT count(id) FROM dist WHERE file_build_pl=1");
__PACKAGE__->set_sql('build_and_make',
                     "SELECT count(id) FROM dist WHERE file_build_pl=1 and file_makefile_pl=1");
__PACKAGE__->set_sql('no_buildtool',
                     "SELECT count(id) FROM dist WHERE file_build_pl=0 and file_makefile_pl=0");
					 
					 
sub show :Exported {
	my ($self, $r) = @_;

	#warn "show";
	#use Data::Dumper;
	#warn Dumper $r;
	#my $path_info = $r->{cgi}->path_info;
	#if ($path_info =~ m{/authors/view/(\w+)}) {
	#	$r->{template_args}{details} = [__PACKAGE__->search_details($1)];
	#}
	$r->{template_args}{kwalitee_distribution} = [__PACKAGE__->search_kwalitee_distribution()];
	$r->{template_args}{meta_yml} = __PACKAGE__->sql_meta_yml->select_val;
	$r->{template_args}{total}    = __PACKAGE__->sql_total->select_val;
	$r->{template_args}{meta_yml_perc} = int $r->{template_args}{meta_yml}*100/	$r->{template_args}{total};
	
	$r->{template_args}{meta_yml_2004}    = __PACKAGE__->sql_meta_yml_2004->select_val;
	$r->{template_args}{total_2004}       = __PACKAGE__->sql_total_2004->select_val;
	$r->{template_args}{meta_yml_perc_2004} = int $r->{template_args}{meta_yml_2004}*100/	$r->{template_args}{total_2004};


	$r->{template_args}{make}    = __PACKAGE__->sql_make->select_val;
	$r->{template_args}{build}    = __PACKAGE__->sql_build->select_val;
	$r->{template_args}{build_and_make}    = __PACKAGE__->sql_build_and_make->select_val;
	$r->{template_args}{no_buildtool}    = __PACKAGE__->sql_no_buildtool->select_val;


	#$r->{template} = "show";
}


1;

