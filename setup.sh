#!/bin/sh
SCRIPT=`readlink -f $0`
SCRIPTDIR=`dirname $SCRIPT`

for f in .* ; do
    [ $f = '.' ] && continue
    [ $f = '..' ] && continue
    [ $f = '.git' ] && continue
    [ $f = '.gitignore' ] && continue
    ln -sfb $SCRIPTDIR/$f ~/$f
done
