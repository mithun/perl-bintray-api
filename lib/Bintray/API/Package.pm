package Bintray::API::Package;

#######################
# LOAD CORE MODULES
#######################
use strict;
use warnings FATAL => 'all';
use Carp qw(croak carp);

#######################
# LOAD CPAN MODULES
#######################
use Params::Validate qw(validate_with :types);

use Object::Tiny qw(
  name
  repo
  session
);

#######################
# LOAD DIST MODULES
#######################
use Bintray::API::Session;
use Bintray::API::Version;

#######################
# PUBLIC METHODS
#######################

## Constructor
sub new {
    my ( $class, @args ) = @_;

    my %opts = validate_with(
        params => [@args],
        spec   => {
            session => {
                type => OBJECT,
                isa  => 'Bintray::API::Session',
            },
            name => {
                type => SCALAR,
            },
            repo => {
                type => OBJECT,
                isa  => 'Bintray::API::Repo',
            },
        },
    );

  return $class->SUPER::new(%opts);
} ## end sub new

## Version Object
sub version {
    my ( $self, @args ) = @_;

    my %opts = validate_with(
        params => [@args],
        spec   => {
            name => {
                type => SCALAR,
            },
        },
    );

  return Bintray::API::Version->new(
        session => $self->session(),
        package => $self,
        name    => $opts{name},
    );
} ## end sub version

#######################
# API METHODS
#######################

## Package Info
sub info {
    my ($self) = @_;
  return $self->session()->talk(
        path => join( '/',
            'packages',            $self->repo()->subject()->name(),
            $self->repo()->name(), $self->name(),
        ),
        anon => 1,
    );
} ## end sub info

## Update Package
sub update {
    my ( $self, @args ) = @_;

    my %opts = validate_with(
        params => [@args],
        spec   => {
            details => {
                type => HASHREF,
            },
        },
    );

    # Create JSON
    my $json = $self->session()->json()->encode( $opts{details} );

    # POST
  return $self->session()->talk(
        method => 'PATCH',
        path   => join( '/',
            'packages',            $self->repo()->subject()->name(),
            $self->repo()->name(), $self->name(),
        ),
        content => $json,
    );
} ## end sub update

## Create Version
sub create_version {
    my ( $self, @args ) = @_;

    my %opts = validate_with(
        params => [@args],
        spec   => {
            details => {
                type => HASHREF,
            },
        },
    );

    # Create JSON
    my $json = $self->session()->json()->encode( $opts{details} );

    # POST
  return $self->session()->talk(
        method => 'POST',
        path   => join( '/',
            'packages',            $self->repo()->subject()->name(),
            $self->repo()->name(), $self->name(),
            'versions', ),
        content => $json,
    );
} ## end sub create_version

## Delete version
sub delete_version {
    my ( $self, @args ) = @_;

    my %opts = validate_with(
        params => [@args],
        spec   => {
            name => {
                type => SCALAR,
            },
        },
    );

  return $self->session()->talk(
        method => 'DELETE',
        path   => join( '/',
            'packages',            $self->repo()->subject()->name(),
            $self->repo()->name(), $self->name(),
            'versions',            $opts{name},
        ),
    );
} ## end sub delete_version

#######################
1;

__END__
