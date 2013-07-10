package Bintray::API::Session;

#######################
# LOAD CORE MODULES
#######################
use strict;
use warnings FATAL => 'all';
use Carp qw(croak carp);

#######################
# LOAD CPAN MODULES
#######################
use JSON::Any;
use Encode qw();
use HTTP::Tiny qw();
use URI::Encode qw();
use Params::Validate qw(validate_with :types);
use MIME::Base64 qw(encode_base64);
use Object::Tiny qw(
  username
  apikey
  debug
  client
  urlencoder
  json
);

#######################
# PUBLIC METHODS
#######################

## Constructor
sub new {
    my ( $class, @args ) = @_;
    my %opts = validate_with(
        params => [@args],
        spec   => {
            username => {
                type => SCALAR,
            },
            apikey => {
                type => SCALAR,
            },
            debug => {
                type    => BOOLEAN,
                default => 0,
            },
        },
    );

    # Init HTTP Client
    $opts{client} = HTTP::Tiny->new(
        agent           => 'perl-bintray-api-client',
        default_headers => {
            'Accept'        => 'application/json',
            'Content-Type'  => 'application/json',
            'Authorization' => sprintf( '%s %s',
                'Basic', encode_base64( join( ':', $opts{username}, $opts{apikey} ), '' ),
            ),
        },
    );

    # Init Encoder
    $opts{urlencoder} = URI::Encode->new();

    # Init JSON
    $opts{json} = JSON::Any->new(
        utf8 => 1,
    );

    # Return Object
    my $self = $class->SUPER::new(%opts);
  return $self;
} ## end sub new

#######################
1;

__END__

#######################
# POD SECTION
#######################
=pod

=head1 NAME

=head1 DESCRIPTION

=head1 SYNOPSIS

=cut
