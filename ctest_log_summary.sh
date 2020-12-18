# extract summary from ctest log files

set -e

old_pwd=$(pwd)
cb
logfile="$PWD/Testing/Temporary/LastTest.log"

if [ ! -f "$logfile" ]; then
    echo "failed to find ctest log file $logfile"
    cd "$old_pwd"
    exit 1
fi

if [[ "$(grep -c "^RESULT " "$logfile")" != 0 ]]; then
    echo
    echo " --- BENCHMARKS --- "
    grep --color=never -A 1 "^RESULT " "$logfile"
    echo
fi

echo
echo " --- ALL PASSED TESTS --- "
grep --color=never "^PASS " "$logfile"
echo
echo $(grep -c "^PASS " "$logfile")" passed tests in total"

if [[ "$(grep -c "^XFAIL " "$logfile")" != 0 ]]; then
    echo
    echo " --- EXPECTED FAILURES --- "
    perl -ne '(/^^XFAIL/../^   Loc:/) && print' "$logfile"
    echo
    echo $(grep -c "^XFAIL" "$logfile")" expected failed tests in total"
    echo
fi

if [[ "$(grep -c "^XPASS " "$logfile")" != 0 ]]; then
    echo
    echo " --- UNEXPECTED PASSES --- "
    perl -ne '(/^^XPASS/../^   Loc:/) && print' "$logfile"
    echo
    echo $(grep -c "^XPASS" "$logfile")" unexpected passed tests in total"
    echo
fi

echo
echo " --- ALL FAILED TESTS --- "
perl -ne '(/^^FAIL!/../^   Loc:/) && print' "$logfile"
echo
echo $(grep -c "^FAIL!" "$logfile")" failed tests in total"
echo
grep --color=never "^QFATAL : " "$logfile"
grep --color=never -B 5 "^Segmentation fault" "$logfile"

cd "$old_pwd"
