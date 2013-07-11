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

my $s = $bt->session;
p $s->paginate(
    path  => '/search/users',
    query => [ { name => 'bob' }, ],
);
