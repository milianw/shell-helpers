#!/bin/bash

p=$1

t=$(pwd)/$1
s=$(pwd)/$1_commits.log

if [[ ! -d "$t" || ! -f "$s" ]]; then
  echo "invalid arg"
  exit
fi

pushd $(pwd) &>/dev/null

cs $p || exit

i=0
egrep "^commit " $s | cut -s -d " " -f 2 | tac | while read c; do
  f=$(git log --oneline $c^..$c --)
  f=$(echo $(printf "%03d" $i)-$f.patch | tr " " "_" | sed "s#/##g")
  git show $c > "$t/$f"
  let i=i+1
done

popd &>/dev/null

cd $1 || exit
