#!/bin/bash


suffix=""
if [[ "$KF5_OPT" == "1" ]]; then
  suffix="-opt"
fi

export KF5="/home/milian/projects/compiled/kf5$suffix"
export KDE_SRC=/home/milian/projects/kde/src
export QML2_IMPORT_PATH=/usr/lib/qt6/qml

prepend XDG_DATA_DIRS /usr/share
prepend XDG_CONFIG_DIRS /etc/xdg
add_env $KF5
prepend PATH ~/.bin/kf5
export QML_IMPORT_PATH=$QML2_IMPORT_PATH

prepend LIBEXEC_PATH /usr/lib
prepend LIBEXEC_PATH $KF5/lib

# export QT_MESSAGE_PATTERN='%{appname}(%{pid})/%{category} %{function}: %{message}'
c=$(echo -e "\033")
#export QT_MESSAGE_PATTERN="$c[31m%{if-debug}$c[34m%{endif}%{type}: %{appname}%{if-category}/%{category}%{endif}/%{function}$c[0m: %{message} [%{file}:%{line}/pid=%{pid}]"
export QT_MESSAGE_PATTERN="%{time process} $c[31m%{if-debug}$c[34m%{endif}%{if-info}$c[32m%{endif}%{if-critical}$c[33m%{endif}%{type}: %{if-category}%{category}/%{endif}%{function}[%{file}:%{line}]$c[0m: %{message}%{if-fatal} @ %{backtrace depth=50}%{endif}"
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
