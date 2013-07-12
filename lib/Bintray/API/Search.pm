package Bintray::API::Search;

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
  session
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
            max_results => {
                type    => SCALAR,
                regex   => qr/^\d+$/x,
                default => '100',
            },
        },
    );

  return $class->SUPER::new(%opts);
} ## end sub new

#######################
# API METHODS
#######################

## Search Repos
sub repos {
    my ( $self, @args ) = @_;
    my %opts = validate_with(
        params => [@args],
        spec   => {
            name => {
                type    => SCALAR,
                default => '',
            },
            desc => {
                type    => SCALAR,
                default => '',
            },
        },
    );

    # Need either name or description
    $opts{name}
      or $opts{desc}
      or croak "ERROR: Please provide a name or desc to search for ...";

  return $self->session()->talk(
        path  => '/search/repos',
        query => [
            ( $opts{name} ? { name => $opts{name} } : () ),
            ( $opts{desc} ? { desc => $opts{desc} } : () ),
        ],
    );
} ## end sub repos

## Search Users
sub users {
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
        path  => '/search/users',
        query => [ { name => $opts{name} }, ],
    );
} ## end sub users

#######################
1;

__END__
