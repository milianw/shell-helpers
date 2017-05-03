#!/bin/bash

pattern=$1
shift 1

if [[ "$pattern" == */* ]]; then
    # pattern contains a path, match whole name
    find $@ -iwholename "*$pattern*"
else
    # pattern is just part of the file name
    find $@ -iname "*$pattern*"
fi