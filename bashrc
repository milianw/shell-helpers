# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

. /usr/share/git/completion/git-completion.bash
. /usr/share/git/git-prompt.sh

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Comment in the above and uncomment this below for a color prompt
export GIT_PS1_SHOWDIRTYSTATE=yes
export GIT_PS1_SHOWUPSTREAM="auto"
#export GIT_PS1_SHOWUNTRACKEDFILES=yes
#export GIT_PS1_SHOWSTASHSTATE=yes
PS1='┌${debian_chroot:+($debian_chroot)}\[\033[00;35m\]\u\[\033[00m\]:\[\033[00;33m\]\w\[\033[32m\]$(__git_ps1 \|%s)\[\033[00m\]\n└\$ '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
    ;;
*)
    ;;
esac

. ~/.bin/bash_aliases

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

#xhost +local:

. ~/.bin/keychain.sh
. ~/.bin/bash_setup_programming
add_env "$HOME/projects/compiled/other"

export EDITOR=nano
export GNUTERM=qt

set +o histexpand

export LANGUAGE=en_US

if [[ "$HOSTNAME" == "agathebauer" ]]; then
#    export CC=/usr/bin/clang
#    export CXX=/usr/bin/clang++
    prepend PATH /usr/lib/ccache/bin
    export CC=gcc
    export CXX=g++
elif [[ "$HOSTNAME" == "minime" ]]; then
    export CC="ccache /home/milian/.bin/clang -Qunused-arguments"
    export CXX="ccache /home/milian/.bin/clang++ -Qunused-arguments"
    export CCACHE_CPP2=yes
else
    export CC=gcc
    export CXX=g++
    prepend PATH /usr/lib/icecream/libexec/icecc/bin
    export MAKEFLAGS="-j40"
    export NINJAFLAGS="-j40"
fi

export XAUTHORITY=~/.Xauthority
prepend PATH $HOME/.bin

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk

export PYTHONPATH=/home/milian/projects/compiled/other/lib/python3.6/site-packages

# colorize man output, see:
# http://boredzo.org/blog/archives/2016-08-15/colorized-man-pages-understood-and-customized
man() {
    env \
        LESS_TERMCAP_mb=$'\e[1;31m' \
        LESS_TERMCAP_md=$'\e[1;36m' \
        LESS_TERMCAP_me=$'\e[0m' \
        LESS_TERMCAP_se=$'\e[0m' \
        LESS_TERMCAP_so=$'\e[1;40;92m' \
        LESS_TERMCAP_ue=$'\e[0m' \
        LESS_TERMCAP_us=$'\e[1;33m' \
            man "$@"
}

export GOPATH=$HOME/projects/go
export UBSAN_OPTIONS=print_stacktrace=1

export LD_LIBRARY_PATH=$(echo $LD_LIBRARY_PATH | sed -E 's/:$//')
