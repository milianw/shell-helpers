#!/bin/bash

# opens an URL in a browser, but uses the fastest way possible
# by checking which browser is already open and using that for the URL
# if no browser is open it defaults to a browser of your choice
# (use one which opens fast!)

# the order in which to execute the commands
# breaks on success
# available are the following commands:
#
# swiftfox_new_tab
# firefox_new_tab
# konqueror_new_tab
# opera_new_tab
#
# swiftfox_new_win
# firefox_new_win
# konqueror_new_win
# opera_new_win
#
order=(
  firefox_new_tab
  opera_new_tab
  konqueror_new_tab
  konqueror_new_win
)

# nothing should be changed below

# new konqueror tab
function konqueror_new_tab {
  pid=(`pidof konqueror`)
  if [ ${pid[0]} ]; then
  	dcop konqueror-${pid[0]} konqueror-mainwindow#1 show
  	dcop konqueror-${pid[0]} konqueror-mainwindow#1 newTab "$1"
  else
    return 1
  fi
}
# new konqueror window
function konqueror_new_win {
  konqueror "$1"&
}
# helper function for firefox_new_tab and swiftfox_new_tab
function mozlike_new_tab {
  if [ "`pidof $2-bin`" ]; then
    $2 -new-tab "$1"&
  else
    if [ "`pidof $2`" ]; then
      $2 -new-tab "$1"&
    else
      return 1
    fi
  fi
}
# new firefox tab
function firefox_new_tab {
  mozlike_new_tab "$1" firefox
}
# new swiftfox tab
function swiftfox_new_tab {
  mozlike_new_tab "$1" swiftfox
}
# helper function for firefox_new_win and swiftfox_new_win
function mozlike_new_win {
  $2 -new-tab "$1"&
}
# new firefox window
function firefox_new_win {
  mozlike_new_win "$1" firefox
}
# new swiftfox window
function swiftfox_new_win {
  mozlike_new_win "$1" swiftfox
}
# new opera tab
function opera_new_tab {
  if [ "`pidof opera`" == "" ]; then
    return 1
  fi
  opera -newpage "$1"
}
# new opera win
function opera_new_win {
  opera -newwindow "$1"
}

# call functions based on order defined above
for i in `seq 1 ${#order[@]}`;
do
  ${order[$i-1]} "$1" && exit
done
