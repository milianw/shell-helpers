#!/bin/bash


suffix=""
if [[ "$KF5_OPT" == "1" ]]; then
  suffix="-opt"
fi

export KF5="/home/milian/projects/compiled/kf5$suffix"
export KDE_SRC=/home/milian/projects/kf5/src


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

prepend XDG_DATA_DIRS /usr/share
prepend XDG_DATA_DIRS $KF5/share
prepend XDG_CONFIG_DIRS /etc/xdg
prepend XDG_CONFIG_DIRS $KF5/etc/xdg
prepend PATH $KF5/bin
prepend PATH ~/.bin/kf5
prepend QT_PLUGIN_PATH $KF5/lib/plugins:$KF5/lib64/plugins:$KF5/lib/x86_64-linux-gnu/plugins
prepend QML2_IMPORT_PATH $KF5/lib/qml:$KF5/lib64/qml:$KF5/lib/x86_64-linux-gnu/qml
export QML_IMPORT_PATH=$QML2_IMPORT_PATH

prepend CMAKE_PREFIX_PATH $KF5
prepend CMAKE_LIBRARY_PATH $KF5/lib
prepend LIBEXEC_PATH /usr/lib
prepend LIBEXEC_PATH $KF5/lib

# export QT_MESSAGE_PATTERN='%{appname}(%{pid})/%{category} %{function}: %{message}'
c=`echo -e "\033"`
#export QT_MESSAGE_PATTERN="$c[31m%{if-debug}$c[34m%{endif}%{type}: %{appname}%{if-category}/%{category}%{endif}/%{function}$c[0m: %{message} [%{file}:%{line}/pid=%{pid}]"
export QT_MESSAGE_PATTERN="%{time process} $c[31m%{if-debug}$c[34m%{endif}%{type}: %{if-category}%{category}/%{endif}%{function}[%{file}:%{line}]$c[0m: %{message}"
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
