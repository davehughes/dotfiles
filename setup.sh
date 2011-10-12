#!/bin/sh
SCRIPT=`readlink -f $0`
SCRIPTDIR=`dirname $SCRIPT`
echo "running in $SCRIPTDIR"

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

CMDT_BASE=$SCRIPTDIR/.vim/bundle/command-t
CMDT_RUBY=$CMDT_BASE/ruby/command-t
cd $CMDT_RUBY
ruby extconf.rb && make && rm Makefile && rm mkmf.log
cd $SCRIPTDIR
