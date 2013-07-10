#!/bin/bash

# Bash Options
# set -u  # Catch undeclared variables

# Debug options
# set -n  # Syntax Check. Script is not executed
# set -r  # Script is executed in restricted shell
# set -v  # Verbose
# set -x  # Prints commands before executing
# set -e  # Stop on any error

declare _distdir=$(pwd)

if [ -e ${_distdir}/lib ]
then
    export PERL5LIB=${_distdir}/lib:$PERL5LIB
fi

if [ -e ${_distdir}/bin ]
then
    export PATH=${_distdir}/bin:$PATH
fi
