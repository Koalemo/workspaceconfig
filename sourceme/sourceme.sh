#!/usr/bin/env bash

ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "Sourcing workspace config from $ROOT"

if [[ -z "$WORKSPACE_SET" ]]; then
ROOT=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    # Set repo root variable
    ROOT="$ROOT/.."



    # Enable dbt command competion
    . $ROOT/sourceme/dbt-completion.sh

    # Export binaries to path
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

    echo "You are all set."
else
    echo "Already set"
fi

export WORKSPACE_SET=1
