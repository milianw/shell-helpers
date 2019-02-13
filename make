#!/bin/sh

if icecream_is_available.sh; then
    export USE_ICECREAM=1
    export MAKEFLAGS="-j40"
    export NINJAFLAGS="-j40"
fi

# specially handle make -f - ..., makeobj cannot handle this otherwise
# required for gpgme building through kdesrc-build
if [ "$1" = "-f" ] && [ "$2" = "-" ]; then
    /usr/bin/make "$@"
else
    GMAKE=/usr/bin/make makeobj "$@"
fi

