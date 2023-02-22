#!/usr/bin/env bash

# Set repo root variable
ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT="$ROOT/.."


# Enable dbt command competion
. $ROOT/sourceme/dbt-completion.sh

# Export binaries to path
echo "Exporting binaries to PATH; prepending it to existing $PATH variable, giving them priority over system binaries."
export PATH="$(find "$ROOT" -type d -name bin -printf '%p:')"$PATH

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
