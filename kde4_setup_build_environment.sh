#!/bin/bash

BASE=$HOME/projects

if [[ "$1" != "" && -d $1 ]]; then
  BASE=$1
  export KDEHOME=$BASE/.kde/
  export LD_LIBRARY_PATH=
  export PKG_CONFIG_PATH=
  export CMAKE_PREFIX_PATH=
  export CMAKE_INCLUDE_PATH=
  export CMAKE_LIBRARY_PATH=
fi

## A script to setup some needed variables and functions for KDE 4 development.
## This should normally go in the ~/.bashrc file of your kde-devel user, so
## that it is executed when a session for that user is started.
##
## If you don't use a separate user, the first section with the
## environment variables should go into a separate script.

# KDE

# this is where the build files are written to
export KDE_BUILD=$BASE/.build/kde4/
# this is where your source code lies
export KDE_SRC=$BASE/kde4/
# this is where your compiled stuff will be installed to
export KDEDIR=$BASE/compiled/kde4

export KDEHOME=$HOME/.kde
export KDETMP=/tmp/kde-$USER
mkdir -p $KDETMP
export KDEDIRS=$KDEDIR
prepend PATH $KDEDIR/bin
prepend PATH $KDEDIR/lib/kde4/libexec
prepend LD_LIBRARY_PATH $KDEDIR/lib
prepend PKG_CONFIG_PATH $KDEDIR/lib/pkgconfig
prepend QT_PLUGIN_PATH $KDEDIR/lib/kde4/plugins

prepend PATH ~/.bin/kde4

prepend CMAKE_PREFIX_PATH $KDEDIR

# CMake
# Make sure CMake searches the right places.
prepend CMAKE_LIBRARY_PATH $KDEDIR/lib
prepend CMAKE_INCLUDE_PATH $KDEDIR/include

# DBus
# only set DBUS related variables if you compiled dbus on your own
# (which is really discouraged). if you use the distro provided dbus,
# skip this variable. Uncomment it if necessary.
#export DBUSDIR=$KDEDIR
#prepend PKG_CONFIG_PATH $DBUSDIR/lib/pkgconfig

# only needed on some strange systems for compiling Qt. do not set
# it unless you have to.
#export YACC='byacc -d'

# XDG
#unset XDG_DATA_DIRS # to avoid seeing kde3 files from /usr
#unset XDG_CONFIG_DIRS
if [[ "$XDG_DATA_DIRS" == "" ]]; then
  XDG_DATA_DIRS=/usr/share
fi
prepend XDG_DATA_DIRS $KDEDIR/share
export XDG_DATA_DIRS
if [[ "$XDG_CONFIG_DIRS" == "" ]]; then
  XDG_CONFIG_DIRS=/usr/share/kde4/config
fi
prepend XDG_CONFIG_DIRS $KDEDIR/share/kde4/config
export XDG_CONFIG_DIRS

# make the debug output prettier
export KDE_COLOR_DEBUG=1
export QTEST_COLORED=1

export LIBRARY_PATH=$LD_LIBRARY_PATH

# Insert Krazy into path if available
if [[ -d /usr/local/Krazy2 ]]; then
  prepend PATH /usr/local/Krazy2/bin
fi

export CS_PATHS=(
    $KDE_SRC/
)

export CMAKE_INSTALL_PREFIX=$KDEDIR
