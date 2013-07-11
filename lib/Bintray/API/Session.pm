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
use MIME::Base64 qw(encode_base64);
use Params::Validate qw(validate_with :types);
use Object::Tiny qw(
  apikey
  apiurl
  client
  debug
  json
  urlencoder
  username
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

    # Set API URL
    $opts{apiurl} = 'https://bintray.com/api/v1';

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

## Talk
sub talk {
    my ( $self, @args ) = @_;
    my %opts = validate_with(
        params => [@args],
        spec   => {
            method => {
                type    => SCALAR,
                default => 'GET',
            },
            path => {
                type => SCALAR,
            },
            query => {
                type    => ARRAYREF,
                default => [],
            },
            params => {
                type    => ARRAYREF,
                default => [],
            },
            content => {
                type    => SCALAR,
                default => '',
            },
            wantheaders => {
                type    => BOOLEAN,
                default => 0,
            },
        },
    );

    # Build URL
    $opts{path} =~ s{^\/}{}x;
    my $url = join( '/', $self->apiurl(), $opts{path} );

    my @query_parts;
    foreach my $_q ( @{ $opts{query} } ) {
        push @query_parts, sprintf( '%s=%s', each %{$_q} );
    }
    if (@query_parts) {
        $url .= '?' . join( '&', @query_parts );
    }

    my @param_parts;
    foreach my $_p ( @{ $opts{params} } ) {
        push @param_parts, sprintf( '%s=%s', each %{$_p} );
    }
    if (@param_parts) {
        $url .= ';' . join( ';', @param_parts );
    }

    # Encode
    $url = $self->urlencoder->encode($url);

    # Talk
    my $response
      = $self->client()
      ->request( $opts{method}, $url,
        { $opts{content} ? ( content => $opts{content} ) : () } );

    # Check Response
  return unless $response->{success};
  return unless $response->{content};

    # Collect Response
    my $api_response = $self->json->decode(
        Encode::decode( 'utf-8-strict', $response->{content} ) );

    # Collect Headers
    my $api_headers = {};
    foreach my $_h ( grep { /^x\-/xi } keys %{ $response->{headers} } ) {
        $api_headers->{$_h} = $response->{headers}->{$_h};
    }

    # Return
    if ( $opts{wantheaders} ) {
      return {
            headers => $api_headers,
            data    => $api_response,
        };
    } ## end if ( $opts{wantheaders...})
  return $api_response;
} ## end sub talk

## Paginate
sub paginate {
    my ( $self, @args ) = @_;
    my %opts = validate_with(
        params => [@args],
        spec   => {
            query => {
                type    => ARRAYREF,
                default => [],
            },
            max => {
                type    => SCALAR,
                default => 200,
                regex   => qr/^\d+$/,
            },
        },
        allow_extra => 1,
    );

    my $max_results    = delete $opts{max};
    my $num_of_results = 0;
    my $start_pos      = 0;
    my $data           = [];
    while (1) {

        # Talk
        my $response = $self->talk(
            %opts,
            wantheaders => 1,
            query       => [ { start_pos => $start_pos }, @{ $opts{query} }, ],
        );
      last if not defined $response;

        # Check data
        if ( ref( $response->{data} ) eq 'ARRAY' ) {
            push @$data, @{ $response->{data} };
            $num_of_results += scalar( @{ $response->{data} } );
        } ## end if ( ref( $response->{...}))
        else {
            $data = $response->{data};
          last;
        } ## end else [ if ( ref( $response->{...}))]

        # Get position
        my $_total = $response->{headers}->{'x-rangelimit-total'}    || 0;
        my $_start = $response->{headers}->{'x-rangelimit-startpos'} || 0;
        my $_end   = $response->{headers}->{'x-rangelimit-endpos'}   || 0;
        my $_per_page = $_end - $_start;

        # Update Current
        $start_pos = $_end + 1;

        # Continue paging?
      last if ( $num_of_results >= $max_results );
      last if ( $num_of_results >= $_total );
    } ## end while (1)

    # Return
    if ( $opts{wantheaders} ) {
      return { data => $data };
    }
  return $data;
} ## end sub paginate

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
