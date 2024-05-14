#!/bin/sh
# specially handle make -f - ..., makeobj cannot handle this otherwise
# required for gpgme building through kdesrc-build
if [ "$1" = "-f" ] && [ "$2" = "-" ]; then
    /usr/bin/make "$@"
else
    export PATH=$(dirname $0):$PATH
    makeobj "$@"
fi

