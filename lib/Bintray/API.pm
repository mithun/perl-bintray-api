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
use Bintray::API::Search;
use Bintray::API::Session;
use Bintray::API::Subject;

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


sub subject {
  return Bintray::API::Subject->new(
        session => shift->session,
        @_,
    );
} ## end sub subject

#######################
1;

__END__

#######################
# POD SECTION
#######################
=pod

=head1 NAME

Bintray::API - Perl interface to the Bintray API

=head1 SYNOPSIS

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

=head1 DESCRIPTION

L<Bintray|http://bintray.com> is a L<social platform for community-based software distribution|https://bintray.com/docs/bintrayuserguide.html#_what_is_bintray>.

This module provides a Perl wrapper to the L<Bintray REST API|https://bintray.com/docs/api.html>.

=head1 API Methods

This module is structured similar to L<Bintray Entities|https://bintray.com/docs/bintrayuserguide.html#_bintray_entities>.

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
