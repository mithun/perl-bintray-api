#!/usr/bin/perl

####################
# LOAD CORE MODULES
####################
use strict;
use warnings FATAL => 'all';

# Autoflush ON
local $| = 1;

use Bintray::API;

# Initialize
my $btray = Bintray::API->new(
    username => 'user',
    apikey   => 'XXXXXXXXXXXXXXXXX',
);

# Repository
my $repo = $btray->subject()->repo( name => 'myrepo' );
foreach my $pkg ( $repo->packages() ) {
    print $pkg->{name} . "\n";
}

# Packages and Versions
my $package = $repo->package( name => 'mypackage' );
my $version = $package->version( name => '1.0' );
my $version_info = $version->info();

# Upload and Publish a file
$version->upload(
    file      => '/path/to/local/file',
    repo_path => 'myfiles/file',
    publish   => 1,
);

