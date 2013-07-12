package Bintray::API;

#######################
# LOAD MODULES
#######################
use strict;
use warnings FATAL => 'all';
use Carp qw(croak carp);

#######################
# VERSION
#######################
our $VERSION = '0.01';

#######################
# LOAD CPAN MODULES
#######################
use Object::Tiny qw(session);

#######################
# LOAD DIST MODULES
#######################
use Bintray::API::Session;
use Bintray::API::Search;

#######################
# PUBLIC METHODS
#######################

## ====================
## CONSTRUCTOR
## ====================
sub new {
    my ( $class, @args ) = @_;

    # Set Session
    my %opts;
    $opts{session} = Bintray::API::Session->new(@args);

    # Return Object (tiny)
  return $class->SUPER::new(%opts);
} ## end sub new

## ====================
## Bintray OBJECTS
## ====================
sub search {
  return Bintray::API::Search->new(
        session => shift->session,
        @_,
    );
} ## end sub search

#######################
1;

__END__

#######################
# POD SECTION
#######################
=pod

=head1 NAME

Bintray::API

=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 DEPENDENCIES

=head1 BUGS AND LIMITATIONS

Please report any bugs or feature requests to
C<bug-bintray-api@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/Public/Dist/Display.html?Name=Bintray-API>

=head1 AUTHOR

Mithun Ayachit C<mithun@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2013, Mithun Ayachit. All rights reserved.

This module is free software; you can redistribute it and/or modify it
under the same terms as Perl itself. See L<perlartistic>.

=cut
