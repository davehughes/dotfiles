#!/usr/bin/env bash
OS=`uname -a | cut -d" " -f 1`
if [ "$OS" == "Darwin" ]; then
    reattach-to-user-namespace $@
else
    exec "$@"
fi
