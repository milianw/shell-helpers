#!/bin/bash

if [[ "$(which ksshaskpass)" != "" ]]; then
  export SSH_ASKPASS=ksshaskpass
fi

if [[ "$USER" != "root" ]]; then
  if [[ "$(hostname)" == "agathemoarbauer" ]]; then
    keychain --agents ssh ~/.ssh/id_ed25519
  else
    keychain --agents ssh ~/.ssh/kde_id_dsa ~/.ssh/kdab ~/.ssh/kde_id_v2
  fi
fi

if [[ -f $HOME/.keychain/$HOSTNAME-sh ]]; then
  source $HOME/.keychain/$HOSTNAME-sh
fi
