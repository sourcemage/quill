#!/bin/bash

INSTALL_ROOT="$2"

if [[ "$1" == "install" ]]; then
  if ! grep -q "\./install.sh$" <<< "$0"; then
    echo "This script must be ran from the quill checkout dir!"
    exit 1
  fi
  mkdir -vp $INSTALL_ROOT/usr/bin
  mkdir -vp $INSTALL_ROOT/usr/share/doc/quill
  mkdir -vp $INSTALL_ROOT/var/lib/quill/modules
  cp -vr usr var $INSTALL_ROOT/
fi

if [[ "$1" == "uninstall" ]]; then
  rm -v $INSTALL_ROOT/usr/bin/quill
  rm -rv $INSTALL_ROOT/var/lib/quill/
  rm -rv $INSTALL_ROOT/usr/share/doc/quill
fi
