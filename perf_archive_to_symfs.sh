#!/bin/bash
#
# usage:
#
# tar -xvf perf.data.tar.bz2
# perf_archive_to_symfs.sh .debug
# perf report --symfs $PWD ...
#
path="$1"
if [ -z "$path" ]; then
  echo "missing path arg pointing to extracted .debug folder from perf archive"
  exit 1
fi
find "$path" -name elf | while read f; do dir=$(dirname $(dirname $(echo $f))); echo $dir; target=${dir#$path}; echo $target; mkdir -p $(dirname $target); cp $f $target; done
