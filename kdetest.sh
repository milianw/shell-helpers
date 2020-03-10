# run a given unit-test or all via ctest

set -e

debug=

old_pwd=$(pwd)
cb

if [[ "$1" == "--debug" ]]; then
    debug=$1
    shift 1
fi

if [[ -d "$1" ]]; then
    cd $1
    shift 1
elif [[ ! -f "$1" && -d "$(dirname $1)" ]]; then
    cd $(dirname $1)
    shift 1
fi

tests=$(listCTests $debug)

if [[ "$tests" == "" ]]; then
    echo "this directory does not contain any unit tests!"
    echo
    cd "$old_pwd"
    exit 1
fi

base="$HOME/.kde-unit-test"
if [ ! -d "$base" ]; then
    mkdir -p $base || exit 1
fi

tmpfile=/tmp/testoutput_$$
trap "rm -rf $tmpfile" EXIT

oldPS1="$PS1"
PS1="TEST:$PS1"

export QT_MESSAGE_PATTERN="%{category} %{function}: %{message} [%{file}:%{line}]"
export XDG_DATA_HOME="$base/local5"
export XDG_CONFIG_HOME="$base/config5"
export XDG_CACHE_HOME="$base/cache5"

if [[ "$1" != "" ]]; then
    test=$1
if [[ "$debug" == "--debug" ]]; then
    test=${test/.shell/}
fi
shift 1
args=$@

if [ ! -f "$test" ] || ! in_array "$test" $tests ; then
    if in_array "$test.shell" $tests; then
        test="$test".shell
    else
        echo "could not find unittest '$test'. available are:"
        echo $tests
        echo
        cd "$old_pwd"
        exit 1
    fi
fi

if [[ "$debug" != "" ]]; then
    gdb --eval-command="run" --args ./$test -maxwarnings 0 $args 2>&1 | tee -a "$tmpfile"
else
    ./$test -maxwarnings 0 $args 2>&1 | tee -a "$tmpfile"
fi

echo
else
    # run all tests
    for test in $tests; do
        if [[ "$debug" != "" ]]; then
            gdb --eval-command="run" --args ./$test -maxwarnings 0 2>&1 | tee -a "$tmpfile"
        else
            ./$test -maxwarnings 0 2>&1 | tee -a "$tmpfile"
        fi
    done
fi

if [[ "$(grep -c "^RESULT " "$tmpfile")" != 0 ]]; then
    echo
    echo " --- BENCHMARKS --- "
    grep --color=never -A 1 "^RESULT " "$tmpfile"
    echo
fi

echo
echo " --- ALL PASSED TESTS --- "
grep --color=never "^PASS " "$tmpfile"
echo
echo $(grep -c "^PASS " "$tmpfile")" passed tests in total"

if [[ "$(grep -c "^XFAIL " "$tmpfile")" != 0 ]]; then
    echo
    echo " --- EXPECTED FAILURES --- "
    perl -ne '(/^^XFAIL/../^   Loc:/) && print' "$tmpfile"
    echo
    echo $(grep -c "^XFAIL" "$tmpfile")" expected failed tests in total"
    echo
fi

if [[ "$(grep -c "^XPASS " "$tmpfile")" != 0 ]]; then
    echo
    echo " --- UNEXPECTED PASSES --- "
    perl -ne '(/^^XPASS/../^   Loc:/) && print' "$tmpfile"
    echo
    echo $(grep -c "^XPASS" "$tmpfile")" unexpected passed tests in total"
    echo
fi

echo
echo " --- ALL FAILED TESTS --- "
perl -ne '(/^^FAIL!/../^   Loc:/) && print' "$tmpfile"
echo
echo $(grep -c "^FAIL!" "$tmpfile")" failed tests in total"
echo
grep --color=never "^QFATAL : " "$tmpfile"
grep --color=never -B 5 "^Segmentation fault" "$tmpfile"
