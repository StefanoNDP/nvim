#
# ~/.bashrc
#

#######################################################
# INITIALIZATION START
#######################################################

HOMEPATH="$HOME"

# tty command requires that "stdin" is attached to a terminal
# This prevents "stdin" from being redirected from /dev/null
_GPG_TTY=$(tty)
export GPG_TTY=_GPG_TTY

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# To load ble.sh by default in interactive sessions reliably
# Documentation available at: https://github.com/akinomyoga/ble.sh/wiki
# And replaces ctrl-S with ctrl-R for history navigation to avoid problems with FZF git
if [ -f "$HOMEPATH"/.local/share/blesh/ble.sh ]; then
  source "$HOMEPATH"/.local/share/blesh/ble.sh --noattach && stty -ixon
fi

DEBUGBASH=n

if [[ ${DEBUGBASH,,} = "y" ]]; then
  BASHPROFILELOG="$HOMEPATH"/bashstart.$$.log
  echo "$BASHPROFILELOG"
  PS4='+ $(date "+%s.%N")\011 '
  exec 3>&2 2>"$BASHPROFILELOG"
  set -x
fi

#######################################################
# INITIALIZATION END
#######################################################

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

bind 'set completion-ignore-case on'

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*) ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

DOTNET_TOOLS="/home/sd/.dotnet/tools"
export PATH=$PATH:/snap/bin:$HOME/.local/bin:$HOME/.cargo/bin:$DOTNET_TOOLS

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
DOTNET_CLI_TELEMETRY_OPTOUT=1

export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
export LIBGL_ALWAYS_INDIRECT=0

#######################################################
# EVAL START
#######################################################

# eval "$(ssh-agent -s)"

# if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#     ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
# fi
# if [[ ! -f "$SSH_AUTH_SOCK" ]]; then
#     source "$XDG_RUNTIME_DIR/ssh-agent.env" > /dev/null
# fi

# Load starship prompt if starship is installed
eval "$(starship init bash)"
# if [ -x /usr/bin/starship ]; then
#   __main() {
#     local major="${BASH_VERSINFO[0]}"
#     local minor="${BASH_VERSINFO[1]}"
#
#     if ((major > 4)) || { ((major == 4)) && ((minor >= 1)); }; then
#       # source <("/usr/bin/starship" init bash --print-full-init)
#       source <("/usr/local/bin/starship" init bash --print-full-init)
#     else
#       # source /dev/stdin <<<"$("/usr/bin/starship" init bash --print-full-init)"
#       source /dev/stdin <<<"$("/usr/local/bin/starship" init bash --print-full-init)"
#     fi
#   }
#   __main
#   unset -f __main
# fi

# # Enable auto-completion for pipx
# eval "$(register-python-argcomplete pipx)"
#
# # TheFuck aliases
# eval "$(thefuck --alias)"
# eval "$(thefuck --alias fk)"
# eval "$(thefuck --alias fuck)"
#
# # Enable Zoxide (better cd)
# # eval "$(zoxide init bash)"
# if [ -x /usr/bin/zoxide ]; then
#   __main() {
#     local major="${BASH_VERSINFO[0]}"
#     local minor="${BASH_VERSINFO[1]}"
#
#     if ((major > 4)) || { ((major == 4)) && ((minor >= 1)); }; then
#       source <("/usr/bin/zoxide" init bash)
#     else
#       source /dev/stdin <<<"$("/usr/bin/zoxide" init bash)"
#     fi
#   }
#   __main
#   unset -f __main
# fi
#
# # Atuin, "Magical"
# eval "$(atuin init bash)"

#######################################################
# EVAL END
#######################################################

# # Always work in a tmux session if tmux is installed
# # tmux attach || tmux
# tmux

xset r rate 300 60
