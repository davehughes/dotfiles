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

# Build Command-T ruby extension
CMDT_BASE=$SCRIPTDIR/.vim/bundle/command-t
CMDT_RUBY=$CMDT_BASE/ruby/command-t
cd $CMDT_RUBY
ruby extconf.rb && make && rm Makefile && rm mkmf.log
cd $SCRIPTDIR

# Build vimclojure-nailgun-client
cd /tmp
NGCLIENT_VERSION="2.2.0"
NGCLIENT_PACKAGE="vimclojure-nailgun-client"
wget -O "$NGCLIENT_PACKAGE.zip" "http://kotka.de/projects/vimclojure/$NGCLIENT_PACKAGE-$NGCLIENT_VERSION.zip"
unzip -o "$NGCLIENT_PACKAGE.zip"
cd $NGCLIENT_PACKAGE
make
mv ng $SCRIPTDIR/.vim/bin
cd $SCRIPTDIR



