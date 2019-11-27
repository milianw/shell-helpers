#!/bin/sh

compiler=$(basename $0)
compiler_path=/usr/bin/$compiler
compiler_extra_options=

if [ "$compiler" = "gcc" ] || [ "$compiler" = "g++" ]; then
    compiler_extra_options="$compiler_extra_options -fdiagnostics-color=always"
elif [ "$compiler" = "clang" ] || [ "$compiler" = "clang++" ]; then
    compiler_extra_options="$compiler_extra_options -fcolor-diagnostics"
fi

if [ -z "$USE_ICECREAM" ] || [ "$USE_ICECREAM" = "0" ]; then
    /usr/bin/ccache "$compiler_path" "$@" $compiler_extra_options
else
    /usr/lib64/icecream/bin/icecc "$compiler_path" "$@" $compiler_extra_options
fi
