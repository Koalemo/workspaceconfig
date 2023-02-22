#!/usr/bin/env bash

ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "Sourcing workspace config from $ROOT"

# Set repo root variable
ROOT="$ROOT/.."

# Enable dbt command competion
. $ROOT/sourceme/dbt-completion.sh

#Update path only if we haven't done that yet.
if [[ -z "$WORKSPACE_SET" ]]; then
    # Export binaries to path
    export PATH="$(find "$ROOT" -type d -name bin -printf '%p:')"$PATH
fi

# Export configuration paths
export CONFIGROOT=$ROOT/.config
export SCREENRC=$CONFIGROOT/screen/screenrc
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



# Use "highlight" in place of "cat"
# alias cat="highlight $1 --out-format xterm256 --line-numbers --quiet --force --style solarized-light -D ${SCRATCHPATH}/highlight_data"


# Commodities
alias vvfi="verible-verilog-format --inplace"

alias vvmts="vivado -mode tcl -source "
alias vvmbs="vivado -mode batch -source "

if [[ -z $GOPATH ]]; then
    echo "WARNING: variable GOPATH is not set."
fi

if [[ -z $LM_LICENSE_FILE ]]; then
    echo "WARNING: variable LM_LICENSE_FILE is not set."
fi

if [[ -z $XILINXD_LICENSE_FILE ]]; then
    echo WARNING: variable XILINXD_LICENSE_FILE is not set.
fi
export WORKSPACE_SET=1
