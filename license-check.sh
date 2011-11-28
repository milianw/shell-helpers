#!/bin/bash

if [ ! -d $1 ]; then
  echo "usage: $0 FOLDER"
  exit 1;
fi

function error() {
  echo $1
  exit 1
}

pushd $(pwd) > /dev/null
cs kdesdk-scripts || error "could not find kdesdk-scripts"
checker=$(pwd)/relicensecheck.pl
popd > /dev/null

[ -f $checker ] || error "could not find check script $checker"

cd $1
tmp=/tmp/license-check-$$
find -name "*.cpp" -o -name "*.h" | while read f; do
  ask=$($checker $f | egrep "^\- \+eV:")
  echo $ask | sed 's/- +eV: //' | tr ' ' '\n' >> $tmp
  if [[ "$ask" != "" ]]; then
    echo $f $ask
  else
    echo $f "can be relicensed to +eV!"
  fi
done

echo "~~~~~~~~~~"
echo "people to ask before relicensing:"
sort $tmp | uniq

rm $tmp &>/dev/null

# kate: replace-tabs on; indent-width 2;