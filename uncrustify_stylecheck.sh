#!/bin/bash

#
# A pre-commit hook for GIT
#
# usage: ln -s path/to/this/file your/repo/.git/hooks/pre-commit
#
# alternatively just execute this script from within your existing
# pre-commit hook
#
# setup: create an uncrustify configuration file called
#        format.config.uncrustify and put it into your
#        repo's main directory
#

# working direction == repository root dir

# path to uncrustify configuration file
UNCRUSTIFY_CONFIG_FILE=$(pwd)/format.config.uncrustify
# url or similar that explains your project's coding style
README="http://techbase.kde.org/Projects/KDevelop4/CodingStyle"

if [[ "$(which uncrustify)" == "" ]]; then
  echo "could not find uncrustify in PATH, please install it"
  exit 1;
fi

if [ ! -f "$UNCRUSTIFY_CONFIG_FILE" ]; then
  echo "could not find uncrustify configuration:"
  echo $UNCRUSTIFY_CONFIG_FILE
  exit 1
fi

TEMPDIR=$(mktemp -d)
TEMPOUT=$(mktemp)

HAS_ERROR="NO"

BAD_FILES=

for file in $(git diff --cached --name-only --diff-filter=ACM); do
  if [[ "$(echo "$file" | egrep '^.*\.(h|cpp|hpp|c)$')" == "" ]]; then
    # not a C/C++ file, skip it
    continue
  fi
  # create checkout of changed file, as it would be committed
  git checkout-index --prefix=$TEMPDIR/ -f "$file"
  # call uncrustify and ensure it worked
  if ! uncrustify -l CPP -f "$TEMPDIR/$file" -c "$UNCRUSTIFY_CONFIG_FILE" -o "$TEMPOUT" &> /dev/null; then
    echo
    echo "failed to run uncrustify on file: $file"
    echo "did you try to add an empty file?"
    BAD_FILES=$BAD_FILES"$file\n"
    HAS_ERROR="YES";
  fi
  # create diff
  if ! diff -pu "$TEMPDIR/$file" --label "your $file" "$TEMPOUT" --label "formatted $file"; then
    BAD_FILES=$BAD_FILES"$file\n"
    HAS_ERROR="YES"
  fi
done

rm -Rf $TEMPDIR
rm $TEMPOUT

if [[ "$HAS_ERROR" != "NO" ]]; then
  echo
  echo "ERROR: the following files contain badly formatted code:"
  echo
  echo -e $BAD_FILES
  echo "see also: $README"
  exit 1
fi
