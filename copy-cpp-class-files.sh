#!/bin/bash

if [ "$#" -lt 3 ]; then
    echo "$0 FROM_PATTERN TO_PATTERN FILES..."
    exit 1
fi

from=$1
to=$2
shift 2

isValidCppIdentifierPattern()
{
  [[ "$1" =~ ^[a-zA-Z_][a-zA-Z_0-9]*$ ]]
}

if ! isValidCppIdentifierPattern $from; then
  echo "$from isn't a valid C++ identifer"
  exit 1
fi
if ! isValidCppIdentifierPattern $to; then
  echo "$to isn't a valid C++ identifer"
  exit 1
fi

lowerFrom=${from,,}
lowerTo=${to,,}

replacePattern="s/$from/$to/g; s/$lowerFrom/$lowerTo/g"

echo "applying $replacePattern"

for f in $@; do
  target=$(echo "$f" | sed "$replacePattern" )
  cp -vi "$f" "$target" || continue
  sed -i "$replacePattern" "$target"
done;
