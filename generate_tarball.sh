#!/bin/bash
CURRENTPWD=$PWD
MY_VERSION=$(< var/lib/quill/version)
mkdir ../quill-$MY_VERSION
cd ..
cp -r $CURRENTPWD/* quill-$MY_VERSION/
rm -rf quill-$MY_VERSION/.git quill-$MY_VERSION/usr/bin/quill-old
rm -rf quill-$MY_VERSION/libgnatest
tar -jcvf quill-$MY_VERSION.tar.bz2 quill-$MY_VERSION
gpg --digest-algo SHA512 -u 117869C9 -b quill-$MY_VERSION.tar.bz2
