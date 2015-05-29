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
PS1='${debian_chroot:+($debian_chroot)}\[\033[00;35m\]\u@\h\[\033[00m\]:\[\033[00;33m\]\w\[\033[32m\]$(__git_ps1 \|%s)\[\033[00m\]\$ '

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
export KF5=1
. ~/.bin/bash_setup_kde4_programming

export EDITOR=nano
export GNUTERM=qt

set +o histexpand

export INTEL_LICENSE_FILE=28518@192.168.160.9
