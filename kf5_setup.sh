#!/bin/bash

export KF5=/home/milian/projects/compiled/kf5

source ~/.bashrc

export PS1="KF5:$PS1"

export CC="ccache /home/milian/.bin/clang -Qunused-arguments"
export CXX="ccache /home/milian/.bin/clang++ -Qunused-arguments"

export KDE_SRC=/home/milian/projects/kf5/src
export KDE_BUILD=/home/milian/projects/kf5/build

unset KDEDIR
unset KDEDIRS

function cleankde4 {
    eval $1="\$(echo \"\$$1\" | sed -r 's#(^|:)[^:]+kde4[^:]*##g')"
    export $1
}
cleankde4 PATH
cleankde4 QT_PLUGIN_PATH
cleankde4 LIBRARY_PATH
cleankde4 LD_LIBRARY_PATH
cleankde4 CMAKE_PREFIX_PATH
cleankde4 CMAKE_INCLUDE_PATH
cleankde4 CMAKE_LIBRARY_PATH
cleankde4 PKG_CONFIG_PATH
cleankde4 XDG_CONFIG_DIRS
cleankde4 XDG_DATA_DIRS

unset QTDIR
# export QTDIR=<path to your qt5 sources>/qtbase
# prepend PATH $QTDIR/bin
# prepend QT_PLUGIN_PATH $QTDIR/plugins
# prepend QML2_IMPORT_PATH $QTDIR/qml

prepend XDG_DATA_DIRS $KF5/share
prepend XDG_CONFIG_DIRS $KF5/etc/xdg
prepend PATH $KF5/bin
prepend PATH ~/.bin/kf5
prepend QT_PLUGIN_PATH $KF5/lib/plugins:$KF5/lib64/plugins:$KF5/lib/x86_64-linux-gnu/plugins
prepend QML2_IMPORT_PATH $KF5/lib/qml:$KF5/lib64/qml:$KF5/lib/x86_64-linux-gnu/qml
export QML_IMPORT_PATH=$QML2_IMPORT_PATH
export KDE_SESSION_VERSION=5
export KDE_FULL_SESSION=true

export XDG_DATA_HOME=$HOME/.local5
export XDG_CONFIG_HOME=$HOME/.config5
export XDG_CACHE_HOME=$HOME/.cache5

export CMAKE_PREFIX_PATH=$KF5:$CMAKE_PREFIX_PATH
prepend CMAKE_LIBRARY_PATH $KF5/lib
prepend LD_LIBRARY_PATH $KF5/lib


# export QT_MESSAGE_PATTERN='%{appname}(%{pid})/%{category} %{function}: %{message}'
c=`echo -e "\033"`
export QT_MESSAGE_PATTERN="%{appname}(%{pid})/(%{category}) $c[31m%{if-debug}$c[34m%{endif}%{function}$c[0m: %{message}"
unset c

eval `dbus-launch`
#kdeinit5
