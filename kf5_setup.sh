#!/bin/bash


suffix=""
qtsuffix="-dbg"
if [[ "$KF5_OPT" == "1" ]]; then
  suffix="-opt"
  qtsuffix="-opt"
fi

export KF5="/home/milian/projects/compiled/kf5$suffix"
export KDE_SRC=/home/milian/projects/kf5/src

export PS1="KF5$suffix:$PS1"

# cleanup KDE4 stuff
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
QTDIR=/home/milian/projects/compiled/qt5-x86-dev-$qtsuffix
if [ -d "$QTDIR" ]; then
    export QTDIR
    prepend PATH $QTDIR/bin
    prepend QT_PLUGIN_PATH $QTDIR/plugins
    prepend QML2_IMPORT_PATH $QTDIR/qml
fi

prepend XDG_DATA_DIRS $KF5/share
prepend XDG_CONFIG_DIRS $KF5/etc/xdg
prepend PATH $KF5/bin
prepend PATH ~/.bin/kf5
prepend QT_PLUGIN_PATH $KF5/lib/plugins:$KF5/lib64/plugins:$KF5/lib/x86_64-linux-gnu/plugins
prepend QML2_IMPORT_PATH $KF5/lib/qml:$KF5/lib64/qml:$KF5/lib/x86_64-linux-gnu/qml
export QML_IMPORT_PATH=$QML2_IMPORT_PATH

export CMAKE_PREFIX_PATH=$KF5:$CMAKE_PREFIX_PATH
prepend CMAKE_LIBRARY_PATH $KF5/lib
prepend LD_LIBRARY_PATH $KF5/lib
prepend LIBEXEC_PATH /usr/lib
prepend LIBEXEC_PATH $KF5/lib

prepend CMAKE_PREFIX_PATH $HOME/projects/compiled/other
prepend CMAKE_LIBRARY_PATH $HOME/projects/compiled/other/lib
prepend CMAKE_INCLUDE_PATH $HOME/projects/compiled/other/include
prepend LD_LIBRARY_PATH $HOME/projects/compiled/other/lib
prepend PKG_CONFIG_PATH $HOME/projects/compiled/other/lib/pkgconfig
prepend PATH $HOME/projects/compiled/other/bin

# export QT_MESSAGE_PATTERN='%{appname}(%{pid})/%{category} %{function}: %{message}'
c=`echo -e "\033"`
export QT_MESSAGE_PATTERN="%{appname}(%{pid})/(%{category}) $c[31m%{if-debug}$c[34m%{endif}%{function}$c[0m: %{message}"
unset c

export CS_PATHS=(
    ${CS_PATHS[@]}
    $KDE_SRC/extragear/base
    $KDE_SRC/extragear/graphics
    $KDE_SRC/extragear/kdevelop
    $KDE_SRC/extragear/kdevelop/plugins
    $KDE_SRC/extragear/kdevelop/utilities
    $KDE_SRC/extragear/libs
    $KDE_SRC/extragear/network/telepathy
    $KDE_SRC/extragear/sdk
    $KDE_SRC/extragear/utils
    $KDE_SRC/frameworks
    $KDE_SRC/kde/applications
    $KDE_SRC/kde/kdegraphics/libs
    $KDE_SRC/kde/kdelibs
    $KDE_SRC/kde/kdesdk
    $KDE_SRC/kde/kdeutils
    $KDE_SRC/kde/workspace
    $KDE_SRC/kdesupport/phonon
    $KDE_SRC/kdesupport/strigi
    $KDE_SRC/kde-workspace
    $KDE_SRC/playground/devtools/plugins
    $KDE_SRC/playground/libs
)

export CMAKE_INSTALL_PREFIX=$KF5
