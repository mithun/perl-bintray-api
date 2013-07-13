package Bintray::API::Version;

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
  session
  package
);

#######################
# LOAD DIST MODULES
#######################
use Bintray::API::Session;

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
            package => {
                type => OBJECT,
                isa  => 'Bintray::API::Package',
            },
        },
    );

  return $class->SUPER::new(%opts);
} ## end sub new

#######################
# API METHODS
#######################

## Info
sub info {
    my ($self) = @_;
  return $self->session()->talk(
        path => join( '/',
            'packages',                 $self->package->repo->subject->name,
            $self->package->repo->name, $self->package->name,
            $self->name, ),
    );
} ## end sub info

## Update Version
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
            'packages',                 $self->package->repo->subject->name,
            $self->package->repo->name, $self->package->name,
            $self->name, ),
        content => $json,
    );
} ## end sub update

## Get Attributes
sub get_attributes {
    my ( $self, @args ) = @_;

    my %opts = validate_with(
        params => [@args],
        spec   => {
            names => {
                type    => ARRAYREF,
                default => [],
            },
        },
    );

  return $self->session->talk(
        path => join( '/',
            'packages',                 $self->package->repo->subject->name,
            $self->package->repo->name, $self->package->name,
            $self->name,                'attributes',
        ), (
            defined $opts{names}
            ? (
                query => [
                    {
                        names => join( ',', @{ $opts{names} } ),
                    },
                ],
              )
            : (),
        ),
    );
} ## end sub get_attributes

# Set Attributes
sub set_attributes {
    my ( $self, @args ) = @_;

    my %opts = validate_with(
        params => [@args],
        spec   => {
            attributes => {
                type => ARRAYREF,
            },
            update => {
                type    => BOOLEAN,
                default => 0,
            },
        },
    );

    # Create JSON
    my $json = $self->session()->json()->encode( $opts{attributes} );

    # POST
  return $self->session()->talk(
        method => $opts{update} ? 'PATCH' : 'POST',
        path => join( '/',
            'packages',                 $self->package->repo->subject->name,
            $self->package->repo->name, $self->package->name,
            $self->name,                'attributes',
        ),
        content => $json,
    );
} ## end sub set_attributes

## Update Attributes
sub update_attributes { return shift->set_attributes( @_, update => 1, ); }

## Test WebHook
sub test_webhook {
    my ($self) = @_;
  return $self->session()->talk(
        method => 'POST',
        path   => join( '/',
            'webhooks',                 $self->package->repo->subject->name,
            $self->package->repo->name, $self->package->name,
            $self->name, ),
        wantheaders => 1,
    );
} ## end sub test_webhook

#######################
1;

__END__
