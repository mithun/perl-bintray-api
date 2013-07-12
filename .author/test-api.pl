#!/usr/bin/perl

####################
# LOAD CORE MODULES
####################
use strict;
use warnings FATAL => 'all';

# Autoflush ON
local $| = 1;

use Bintray::API;
use Data::Printer;

my $bt = Bintray::API->new(

    username => 'mithun',
    apikey   => $ENV{PERL_BINTRAY_API},
);

p $bt->search->packages( name => 'test-pkg' );
