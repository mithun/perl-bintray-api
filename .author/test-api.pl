#!/usr/bin/perl

####################
# LOAD CORE MODULES
####################
use strict;
use warnings FATAL => 'all';

# Autoflush ON
local $| = 1;

####################
# LOAD CPAN MODULES
####################
use Data::Printer {
    output  => 'stdout',
    colored => 1,
    deparse => 1,
    class   => {
        expand => 2,
    },
};
use Term::ANSIColor qw(colored);
use Getopt::Long qw(GetOptions);

####################
# LOAD DIST MODULES
####################
use Bintray::API;

####################
# READ OPTIONS
####################
my %opts = (
    u => 0,  # User
    r => 0,  # repo
    p => 0,  # Package
    v => 0,  # version
    f => 0,  # File upload
    s => 0,  # search
    a => 0,  # All
);
GetOptions( \%opts, 'u', 'r', 'p', 'v', 'f', 's', 'a', )
  or die "Invalid Options";

if ( $opts{a} ) {
    %opts = map { $_ => 1 } keys %opts;
}

####################
# INIT OBJECT
####################
my $apikey = $ENV{PERL_BINTRAY_API}
  || die "API key is not defined in PERL_BINTRAY_API";
my $bt = Bintray::API->new(
    username => 'mithun',
    apikey   => $apikey,
    debug    => 1,
);
_dump(
    o => $bt,
    m => 'Main Bintray::API Object'
);

####################
# OBJECTS
####################
my $user = $bt->subject( name => 'mithun' );
my $repo = $user->repo( name => 'test-repo' );
my $pkg = $repo->package( name => 'test-pkg' );
my $version = $pkg->version( name => 'test-ver' );

my $attr      = 'test-attr';
my $file      = $0;
my $repo_path = 'foo/bar/my/file';

####################
# USER
####################
if ( $opts{u} ) {
    _dump(
        o => [$user],
        m => 'User Object',
    );
    _dump(
        o => [ $user->info() ],
        m => 'User Info',
    );
    _dump(
        o => [ $user->followers() ],
        m => 'User Followers',
    );
    _dump(
        o => [ $user->repos() ],
        m => 'User repos',
    );
    _dump(
        o => [ $user->get_webhooks() ],
        m => 'User hooks',
    );
} ## end if ( $opts{u} )

####################
# REPOS
####################
if ( $opts{r} ) {
    _dump(
        o => [$repo],
        m => 'repo Object',
    );
    _dump(
        o => [ $repo->info() ],
        m => 'repo info',
    );
    _dump(
        o => [ $repo->packages() ],
        m => 'repo packages',
    );
    _dump(
        o => [
            $repo->create_package(
                details => {
                    name     => 'test-pkg2',
                    desc     => 'test api',
                    labels   => [qw(foo)],
                    licenses => [ 'GPL-3.0', 'Artistic-License-2.0', ],
                }
            )
        ],
        m => 'repo create packages',
    );
    _dump(
        o => [ $repo->delete_package( name => 'test-pkg2' ) ],
        m => 'repo delete packages',
    );
    _dump(
        o => [ $repo->get_webhooks() ],
        m => 'repo hooks',
    );
    _dump(
        o => [ $repo->package_names() ],
        m => 'repo package names',
    );
} ## end if ( $opts{r} )

####################
# PACKAGE
####################
if ( $opts{p} ) {
    _dump(
        o => [$pkg],
        m => 'package object',
    );
    _dump(
        o => [ $pkg->info() ],
        m => 'package info',
    );
    _dump(
        o => [
            $pkg->update(
                details => {
                    desc     => 'test api',
                    labels   => [qw(foo)],
                    licenses => [ 'GPL-3.0', 'Artistic-License-2.0', ],
                }
            )
        ],
        m => 'package update',
    );
    _dump(
        o => [
            $pkg->create_version(
                details => {
                    name          => 'foobar',
                    release_notes => 'foobar',
                    release_url   => 'http://foo/bar'
                }
            )
        ],
        m => 'package create_version',
    );
    _dump(
        o => [ $pkg->delete_version( name => 'foobar' ) ],
        m => 'package delete_version',
    );
    _dump(
        o => [ $pkg->get_attributes() ],
        m => 'package get_attributes',
    );
} ## end if ( $opts{p} )

####################
# VERSION
####################
if ( $opts{v} ) {
    _dump(
        o => [$version],
        m => 'version object',
    );
    _dump(
        o => [ $version->info() ],
        m => 'version info',
    );
    _dump(
        o => [
            $version->update(
                details => {
                    release_notes => 'foobar',
                    release_url   => 'http://foo/bar'
                }
            )
        ],
        m => 'version update',
    );
    _dump(
        o => [ $version->get_attributes() ],
        m => 'version get_attributes',
    );
    _dump(
        o => [ $version->test_webhook() ],
        m => 'version test_webhook',
    );
    _dump(
        o => [
            $version->upload(
                file      => $file,
                repo_path => $repo_path
            )
        ],
        m => 'version upload',
    );
    _dump(
        o => [ $version->publish() ],
        m => 'version publish',
    );
    _dump(
        o => [ $version->discard() ],
        m => 'version discard',
    );
} ## end if ( $opts{v} )

####################
# DONE
####################
exit 0;

####################
# INTERNAL
####################
sub _dump {
    my (%d) = @_;
    print colored( [qw(bold bright_white)],
        sprintf( "%s\n  -> %s\n%s\n", '#' x 25, uc $d{m}, '#' x 25 ) );
    p $d{o};
  return 1;
} ## end sub _dump
