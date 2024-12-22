# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

if [ -f /usr/share/git/completion/git-completion.bash ]; then
    . /usr/share/git/completion/git-completion.bash
    . /usr/share/git/git-prompt.sh
else
    . /usr/share/bash-completion/bash_completion
fi

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

# Comment in the above and uncomment this below for a color prompt
export GIT_PS1_SHOWDIRTYSTATE=yes
export GIT_PS1_SHOWUPSTREAM="auto"
#export GIT_PS1_SHOWUNTRACKEDFILES=yes
#export GIT_PS1_SHOWSTASHSTATE=yes
export PROMPT_DIRTRIM=1
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

if [ ! -z "$(command -v keychain 2> /dev/null)" ]; then
    . ~/.bin/keychain.sh
fi

. ~/.bin/bash_setup_programming
add_env "$HOME/projects/compiled/other"

export EDITOR=nano
export GNUTERM=qt

set +o histexpand

export LANGUAGE=en_US

export CC=$HOME/.bin/gcc
export CXX=$HOME/.bin/g++

prepend PATH $HOME/.local/bin
prepend PATH $HOME/.bin

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk

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

if [ ! -z "$(command -v powerline-daemon 2> /dev/null)" ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/lib/python3.13/site-packages/powerline/bindings/bash/powerline.sh
fi

# I still want to load my qtlogging.ini even when setFilterRules was used...
export QT_LOGGING_CONF=$HOME/.config/QtProject/qtlogging.ini
export CMAKE_GENERATOR=Ninja
export CMAKE_EXPORT_COMPILE_COMMANDS=ON

eval "$(zoxide init bash --cmd j)"

FZF_CTRL_T_COMMAND="fd"
FZF_ALT_C_COMMAND="fd -t d"

if [ -f /usr/share/fzf/completion.bash ]; then
    . /usr/share/fzf/completion.bash
    . /usr/share/fzf/key-bindings.bash
else
    . /usr/share/doc/fzf/examples/key-bindings.bash
fi

if [[ "$(hostname)" == "milian-workstation" || "$(hostname)" == "agathemoarbauer" ]]; then
    export USE_ICECREAM=0
fi

if [[ ! -z "$SSH_CONNECTION" ]]; then
    export QT_QPA_PLATFORMTHEME=kde
fi

export LESS=-mRFS
export ACK_PAGER=less

eval "$(direnv hook bash)"
