#!perl

####################
# LOAD MODULES
####################
use strict;
use warnings FATAL => 'all';
use Module::Build;

# Autoflush ON
local $| = 1;

####################
# INIT BUILDER
####################

my $builder = Module::Build->new(

    # Basic Info
    module_name => 'Bintray::API',
    license     => 'perl',
    dist_author => 'Mithun Ayachit <mithun@cpan.org>',

    # dist_abstract => '',

    # Directives
    auto_configure_requires => 1,
    create_packlist         => 1,
    create_license          => 1,
    create_makefile_pl      => 'traditional',
    recursive_test_files    => 1,
    add_to_cleanup          => ['Bintray-API-*'],
    sign                    => 1,

    # Prereqs
    build_requires => {
        'Test::More' => 0,
        'Test::Deep' => 0,
        'Test::Pod'  => '1.00',
        'version'    => 0,
    },
    requires => {

    },

    # Recommendations
    recommends => {

    },

    # Meta
    meta_merge => {
        no_index => {
            directory => [ '.author', '.t', 'examples', ],
        },
        keywords  => [qw()],
        resources => {
            bugtracker => 'http://rt.cpan.org/Public/Dist/Display.html?Name=Bintray-API',
            repository => 'git://github.com/mithun/perl-bintray-api.git',
            homepage   => 'https://github.com/mithun/perl-bintray-api',
        },
    },
);

####################
# CREATE BUILD SCRIPT
####################
$builder->create_build_script();
