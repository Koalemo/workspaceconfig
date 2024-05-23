# Install

```
cd path/to/workdpaceconfig/
./install.sh
```

Also, have a look into the file `install.sh` for manual installation instruction.

For ssh to be less annooying:
Add the following to ~/.ssh/rc on each new server:

```
#!/bin/bash

# Fix SSH auth socket location so agent forwarding works with tmux
if test "$SSH_AUTH_SOCK" ; then
  ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi

# And some magic make vanilla X11 forwarding work
if read proto cookie && [ -n "$DISPLAY" ]; then
  echo "add unix:${DISPLAY#localhost:} $proto $cookie" | xauth -q
fi
```

# Activate
Add to .bashrc:
```
pushd path/to/workspaceconfig
. sourceme/sourceme.sh
popd;
```

# How to avoid using stupid jupyter lwb webui:
Use [molten-nvim](https://github.com/benlubas/molten-nvim/blob/main/docs/Probably-Too-Quick-Start-Guide.md)
in your venv:
```
# install pynvim
pip install pynvim

#install jupyter_client:
dbt sync
pushd DEPS/jupyter_client
pip install -e ".[test]"
```
