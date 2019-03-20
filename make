#!/bin/sh

ICECREAM_JOBS=$(icecream_is_available.sh)
if [ ! -z "$ICECREAM_JOBS" ]; then
    export USE_ICECREAM=1
    export MAKEFLAGS="-j$ICECREAM_JOBS"
    export NINJAFLAGS="-j$ICECREAM_JOBS"
fi

# specially handle make -f - ..., makeobj cannot handle this otherwise
# required for gpgme building through kdesrc-build
if [ "$1" = "-f" ] && [ "$2" = "-" ]; then
    /usr/bin/make "$@"
else
    export PATH=$(dirname $0):$PATH
    makeobj "$@"
fi

