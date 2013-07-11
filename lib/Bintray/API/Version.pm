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

use Object::Tiny qw();

#######################
# LOAD DIST MODULES
#######################
use Bintray::API::Session;

#######################
1;

__END__
