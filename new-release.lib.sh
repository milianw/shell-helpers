#!/bin/bash

function new_release {
  p=$1
  shift 1

  cs $p || exit
  cs releaseme || exit

  # assumes format vMAJOR.MINOR
  if [[ "$1" == "" || "$2" == "" || "$3" == "" ]]; then
    echo "$0 TAG_RELEASE TAG_LASTRELEASE [stable|trunk]"
    echo "  example: $0 v0.3 v0.2 stable"
    exit 1
  fi

  tag=$1
  lasttag=$2
  v=$(echo $tag | awk '{print substr($1, 2)}')

  i18nbranch=$3

  echo "creating release for $p $tag (i18n branch: $i18nbranch)"
  echo -n "continue? [Y/n]"
  read response
  if [[ "$response" != "Y" && "$response" != "" ]]; then
    echo "bye"
    exit 2
  fi

  pushd . &> /dev/null
  cs $p
  git fetch origin

  gitchangelog $lasttag $tag > /tmp/CHANGELOG.$v
  popd &> /dev/null
  ./$p.rb --src ~/projects/kde4/$p/ --git-branch $tag -b $i18nbranch -m 75 -p ssh -v $v -c /tmp/CHANGELOG.$v
}
