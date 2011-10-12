#!/bin/sh
SCRIPT=`readlink -f $0`
SCRIPTDIR=`dirname $SCRIPT`

for f in .* ; do
    [ $f = '.' ] && continue
    [ $f = '..' ] && continue
    [ $f = '.git' ] && continue
    [ $f = '.gitignore' ] && continue
    [ $f = '.ssh' ] && continue
    ln -sfbn $SCRIPTDIR/$f $HOME/$f
    echo "$SCRIPTDIR/$f --> $HOME/$f"
done

for f in .ssh/* ; do
    ln -sfbn $SCRIPTDIR/$f $HOME/$f
    echo "$SCRIPTDIR/$f --> $HOME/$f"
done

git submodule update --init --recursive

CMDT_BASE_DIR=$SCRIPTDIR/.vim/bundle/command-t
CMDT_RUBY_DIR=$CMDT_BASE_DIR/ruby/command-t
ruby $CMDT_RUBY_DIR/extconf.rb
make -C $CMDT_BASE_DIR
