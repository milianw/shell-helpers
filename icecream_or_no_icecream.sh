#!/bin/sh

compiler=/usr/bin/$(basename $0)

if [ -z "$USE_ICECREAM" ]; then
    /usr/bin/ccache "$compiler" "$@"
else
    /usr/lib64/icecream/bin/icecc "$compiler" "$@"
fi
