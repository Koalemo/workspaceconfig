#!/usr/bin/env bash

# TODO (ng): This is just hacked in here. MAy depend on the terminal emulator if this works or not
# Function to extract the last 2 levels from the current path
function CustomPWD {
    # Remove from $PWD the shortest part of /*/* that matches the back end of $var
    tmp=${PWD%/*/*};
    # If tmp is of positive length not equal PWD, print the last characters of PWD.
    # Else, print PWD.
    [ ${#tmp} -gt 0 -a "$tmp" != "$PWD" ] && echo ${PWD:${#tmp}+1} || echo $PWD;
}

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# Create prompt header
PS1='\h:\[\033[1;31m\][$(CustomPWD)]\[\033[32m\]$(parse_git_branch)\[\033[00m\] \$ '
#
# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
   # PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	PS1="\[\e]0;\u@\h: \w\a\]$PS1"
	;;
*)
    ;;
esac

ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "Sourcing workspace config from $ROOT"

# Make history available across all console
# Avoid duplicates
HISTCONTROL=ignoredups:erasedups

# After each command, append to the history file and reread it
PROMPT_COMMAND="${PROMPT_COMMAND:$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# Set repo root variable
ROOT="$ROOT/.."

# Enable dbt command competion
. $ROOT/sourceme/dbt-completion.sh

#Update path only if we haven't done that yet.
if [[ -z "$WORKSPACE_SET" ]]; then
    # Export binaries from workspaceconfig repo to path
    export PATH="$(find "$ROOT" -type d -name bin -printf '%p:')"$PATH


    if [[ -z $TOOLS_PATH ]]; then
        echo WARNING: variable TOOLS_PATH is not set.
    else
        # Export binaries from local tools to path
         export PATH=$PATH"$(find "$TOOLS_PATH" -type d -name bin -printf ':%p')"
    fi
fi

export PATH=$PATH:/home/ng/.npm-global/bin

# Export configuration paths
export CONFIGROOT=$ROOT/config
export NVIMCONFIG=$CONFIGROOT/nvim

# Replace oldvim
echo "Setting aliases"
alias nvim="XDG_DATA_HOME=$NVIMCONFIG/share XDG_CONFIG_HOME=$NVIMCONFIG nvim"
alias vim="XDG_DATA_HOME=$NVIMCONFIG/share XDG_CONFIG_HOME=$NVIMCONFIG nvim"
alias vi="XDG_DATA_HOME=$NVIMCONFIG/share XDG_CONFIG_HOME=$NVIMCONFIG nvim"
alias vimdiff="XDG_DATA_HOME=$NVIMCONFIG/share XDG_CONFIG_HOME=$NVIMCONFIG nvim -d"
export EDITOR=nvim

#shortcuts to open files in new split / tab
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
  alias h='nvr -o'
  alias v='nvr -O'
  alias t='nvr --remote-tab'
fi

# Pipe Highlight to less
export LESSOPEN="| $(which highlight) %s --out-format xterm256 --quiet --force --style solarized-light -D /scratch/msc20f1/highlight_data"
export LESS=" -R"
alias less='less -m -N -g -i -J --line-numbers --underline-special'
#alias less='less -N -m -g -i -J --line-numbers --underline-special'
alias more='less'

# Make tmux use conf file from workspaceconfig:
alias tmux="tmux -f $CONFIGROOT/tmux/tmux.conf"
source $CONFIGROOT/tmux/.tmux-powerlinerc

# Use "highlight" in place of "cat"
# alias cat="highlight $1 --out-format xterm256 --line-numbers --quiet --force --style solarized-light -D ${SCRATCHPATH}/highlight_data"


# Commodities
alias vvfi="verible-verilog-format --inplace"

alias vvmts="vivado -mode tcl -source "
alias vvmbs="vivado -mode batch -source "

alias gt="git ticket"

export HISTSIZE=10000000
export HISTFILESIZE=10000000

if [[ -z $GOPATH ]]; then
    echo "WARNING: variable GOPATH is not set."
fi

if [[ -z $LM_LICENSE_FILE ]]; then
    echo "WARNING: variable LM_LICENSE_FILE is not set."
fi

if [[ -z $XILINXD_LICENSE_FILE ]]; then
    echo WARNING: variable XILINXD_LICENSE_FILE is not set.
fi

if [[ -z $LIBERO_PATH && -z LIBERO_LIC_PATH ]]; then
    echo WARNING: variable LIBERO_PATH and / or LIBERO_LIC_PATH is not set.
else
    # Alias for Libero launch command
    alias libefire='pkill -f lmgrd ; $LIBERO_PATH/lic/lmgrd -c $LIBERO_LIC_PATH/License.dat

    Microchip/Libero/bin/libero'
    alias libedone='pkill -f lmgrd ; pkill -f libero'

    alias libelic='$LIBERO_PATH/lic/lmgrd -c $LIBERO_LIC_PATH/License.dat'
fi


export WORKSPACE_SET=1


# Config file not public. See: https://i.daedalean.ai/infrastructure/s3-clients.html#ddlnfs2
export DDLNFS_S3_CONFIG=~/s3.yaml

set -o vi

