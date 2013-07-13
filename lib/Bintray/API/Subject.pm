package Bintray::API::Subject;

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
);

#######################
# LOAD DIST MODULES
#######################
use Bintray::API::Repo;
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
        },
    );

  return $class->SUPER::new(%opts);
} ## end sub new

# Repository Object
sub repo {
    my ( $self, @args ) = @_;

    my %opts = validate_with(
        params => [@args],
        spec   => {
            name => {
                type => SCALAR,
            },
        },
    );

  return Bintray::API::Repo->new(
        session => $self->session(),
        subject => $self,
        name    => $opts{name},
    );
} ## end sub repo

#######################
# API METHODS
#######################

# Repositories
sub repos {
    my ($self) = @_;

  return $self->session()->talk(
        path => join( '/', 'repos', $self->name() ),
        anon => 1,
    );
} ## end sub repos

## Get Webhooks
sub get_webhooks {
    my ($self) = @_;
  return $self->session->talk(
        path => join( '/', 'webhooks', $self->name() ),
    );
} ## end sub get_webhooks

#######################
# API HELPERS
#######################

# Repository names
sub repo_names {
    my ($self) = @_;
    my $resp = $self->repos() or return;
    my @repos = map { $_->{name} } @{$resp};
  return @repos;
} ## end sub repo_names

#######################
1;

__END__
