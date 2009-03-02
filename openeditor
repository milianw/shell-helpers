#!/bin/bash

# opens a file in the editor of your choice
# good thing: it checks which editor is open and opens the file in that editor
# if no editor is found it defaults to a lightweight editor (like kwrite)

# the order in which to execute the commands
# breaks on success
# available are the following commands:
#
# kwrite_new_win
# quanta_new_win
# kate_new_win
#
# quanta_new_tab
# kate_new_tab
#
order=(
  quanta_new_tab
  kate_new_tab
  kwrite_new_win
)
# nothing should be changed below

# new kate tab
function kate_new_tab {
  isrunning kate || return 1
  echo "open file in a new kate tab:"
  kate -u "$1"
}
# new kate window
function kate_new_win {
  echo "open file in kate:"
  kate "$1"
}
# new kwrite window
function kwrite_new_win {
  echo "open file in kwrite:"
  kwrite "$1"
}
# new quanta window
function quanta_new_win {
  echo "open file in quanta:"
  quanta "$1"
}
# new quanta tab
function quanta_new_tab {
  isrunning quanta || return 1
  echo "open file in new quanta tab:"
  quanta --unique "$1"
}
# check if a process is running
function isrunning {
  pid=(`pidof $1`)
  return `[[ ${pid[0]} ]]`
}

# cached konqueror file
if [[ ${1#/tmp/kde} != $1 || ${1#/var/tmp/kdecache} != $1 ]]; then
#echo "cache" >> /home/milian/.bin/editorlog
  # cached file
  kwrite "$1"
  exit
fi

# call functions based on order defined above
for i in `seq 1 ${#order[@]}`;
do
  ${order[$i-1]} "$1" && exit 0
done
