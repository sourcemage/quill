#!/bin/bash

if [[ $2 ]] ; then
  INSTALL_ROOT="$2"
else
  INSTALL_ROOT=""
fi

if [[ "$1" == "install" ]]; then
  if [[ "$0" != "./install.sh" ]]; then 
    echo "This script must be ran from the quill checkout dir!"
    exit 1
  fi
  mkdir -vp $INSTALL_ROOT/usr/bin
  mkdir -vp $INSTALL_ROOT/var/lib/quill/modules
  cp -r usr var $INSTALL_ROOT/
fi

if [[ "$1" == "uninstall" ]]; then
  rm -v $INSTALL_ROOT/usr/bin/quill
  rm -rv $INSTALL_ROOT/var/lib/quill/
fi
