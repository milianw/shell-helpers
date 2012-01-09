#!/bin/bash

cs releaseme || exit

# assumes format vMAJOR.MINOR
if [[ "$1" == "" || "$2" == "" ]]; then
  echo "new-mv-release.sh TAG_RELEASE TAG_LASTRELEASE"
  echo "  example: new-mv-release.sh v0.3 v0.2"
  exit 1
fi

tag=$1
lasttag=$2
v=$(echo $tag | awk '{print substr($1, 2)}')

# stable release
i18nbranch=stable

echo "creating release for Massif Visualizer $tag (i18n branch: $i18nbranch)"
echo -n "continue? [Y/n]"
read response
if [[ "$response" != "Y" && "$response" != "" ]]; then
  echo "bye"
  exit 2
fi

p="massif-visualizer"

pushd . &> /dev/null
cs $p
git fetch origin

gitchangelog $lasttag $tag > /tmp/CHANGELOG.$v
popd &> /dev/null
./$p.rb --src ~/projects/kde4/$p/ --git-branch $tag -b $i18nbranch -m 75 -u mwolff -p ssh -v $v -c /tmp/CHANGELOG.$v
