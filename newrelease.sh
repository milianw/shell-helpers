#!/bin/bash

# assumes format vMAJOR.MINOR.PATCH or similar
if [[ "$1" == "" || "$2" == "" ]]; then
  echo "newrelease.sh TAG_RELEASE TAG_LASTRELEASE [i18n branch]"
  echo "  example: newrelease.sh v1.0.1 v1.0.0"
  echo "  example: newrelease.sh v4.2.80 v4.2.3 stable"
  exit 1
fi

kdevelop_releasetag=$(echo $1 | awk -F '.' '{print "v" 4 "." $2 "." $3}')
kdevelop_lastreleasetag=$(echo $2 | awk -F '.' '{print "v" 4 "." $2 "." $3}')
kdevelop_version=$(echo $kdevelop_releasetag | awk '{print substr($1, 2)}')

releasetag=$(echo $1 | awk -F '.' '{print "v" 1 "." $2 "." $3}')
lastreleasetag=$(echo $2 | awk -F '.' '{print "v" 1 "." $2 "." $3}')
version=$(echo $releasetag | awk '{print substr($1, 2)}')

minor=${version/*./}

if [ "$minor" -gt "60" ]; then
    # beta realease
    i18nbranch=trunk
else
    # stable release
    i18nbranch=stable
fi

if [[ "$3" == "stable" || "$3" == "trunk" ]]; then
    # overwrite i18n branch:
    i18nbranch=$3
fi

echo "creating release for KDevplatform $version / KDevelop $kdevelop_version (i18n branch: $i18nbranch)"
echo -n "continue? [Y/n]"
read response
if [[ "$response" != "Y" && "$response" != "" ]]; then
  echo "bye"
  exit 2
fi

cs releaseme

for p in kdevplatform kdevelop kdev-php kdev-php-docs; do
  pushd . &> /dev/null
  cs $p
  git fetch origin

  if [[ "$p" == "kdevelop" ]]; then
    v=$kdevelop_version
    from=$kdevelop_lastreleasetag
    to=$kdevelop_releasetag
  else
    v=$version
    from=$lastreleasetag
    to=$releasetag
  fi

  echo "creating release for $p version $v (branch is: $to / $i18nbranch)"
  gitchangelog $from $to > /tmp/CHANGELOG.$v
  popd &> /dev/null
  ./$p.rb --src ~/projects/kde4/$p/ --git-branch $to -b $i18nbranch -m 75 -p ssh -v $v -c /tmp/CHANGELOG.$v
done
