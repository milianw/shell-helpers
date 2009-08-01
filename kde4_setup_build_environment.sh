#!/bin/bash

## A script to setup some needed variables and functions for KDE 4 development.
## This should normally go in the ~/.bashrc file of your kde-devel user, so
## that it is executed when a session for that user is started.
##
## If you don't use a separate user, the first section with the
## environment variables should go into a separate script.

prepend() { [ -d "$2" ] && eval $1=\"$2\$\{$1:+':'\$$1\}\" && export $1 ; }

# Other
# you might want to set a full value for PATH rather than prepend'ing, to make
# sure the your kde3 path isn't in here.
#prepend PATH /usr/local/bin

# Qt
# only set Qt related variables if you compiled Qt on your own
# (which is discouraged). if you use the distro provided Qt, skip
# this section. Comment it if necessary.
# export QTDIR=$HOME/projects/compiled
prepend PATH $QTDIR/bin
prepend LD_LIBRARY_PATH $QTDIR/lib
prepend PKG_CONFIG_PATH $QTDIR/lib/pkgconfig

# KDE

# this is where the build files are written to
export KDE_BUILD=$HOME/projects/.build/kde4/
# this is where your source code lies
export KDE_SRC=$HOME/projects/kde4/
# this is where your compiled stuff will be installed to
export KDEDIR=$HOME/projects/compiled/kde4

export KDEHOME=$HOME/.kde
export KDETMP=/tmp/kde-$USER
mkdir -p $KDETMP
export KDEDIRS=$KDEDIR
prepend PATH $KDEDIR/bin
prepend LD_LIBRARY_PATH $KDEDIR/lib
prepend PKG_CONFIG_PATH $KDEDIR/lib/pkgconfig
prepend QT_PLUGIN_PATH $KDEDIR/lib/kde4/plugins

prepend CMAKE_PREFIX_PATH $QTDIR
prepend CMAKE_PREFIX_PATH $KDEDIR

# CMake
# Make sure CMake searches the right places.
prepend CMAKE_LIBRARY_PATH $QTDIR/lib
prepend CMAKE_INCLUDE_PATH $QTDIR/include
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

# make the debug output prettier
export KDE_COLOR_DEBUG=1
export QTEST_COLORED=1

# Make
# Tell many scripts how to switch from source dir to build dir:
export OBJ_REPLACEMENT="s#$KDE_SRC#$KDE_BUILD#"

export LIBRARY_PATH=$LD_LIBRARY_PATH
