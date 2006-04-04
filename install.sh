#!/bin/bash
if [[ "$1" == "install" ]]
then
mkdir -vp /usr
mkdir -vp /usr/sbin
mkdir -vp /var
mkdir -vp /var/lib
mkdir -vp /var/lib/quill
mkdir -vp /var/lib/quill/modules
cp -v ./usr/bin/quill /usr/sbin/quill
cp -v ./var/lib/quill/modules/libprovides /var/lib/quill/modules/libprovides
cp -v ./var/lib/quill/modules/libdetails /var/lib/quill/modules/libdetails
cp -v ./var/lib/quill/modules/libconflicts /var/lib/quill/modules/libconflicts
cp -v ./var/lib/quill/modules/libconfigure /var/lib/quill/modules/libconfigure
cp -v ./var/lib/quill/modules/libfinal /var/lib/quill/modules/libfinal
cp -v ./var/lib/quill/modules/libbuild /var/lib/quill/modules/libbuild
cp -v ./var/lib/quill/modules/libcore /var/lib/quill/modules/libcore
cp -v ./var/lib/quill/modules/libhistory /var/lib/quill/modules/libhistory
cp -v ./var/lib/quill/modules/libpre_build /var/lib/quill/modules/libpre_build
cp -v ./var/lib/quill/modules/libpre_install /var/lib/quill/modules/libpre_install
cp -v ./var/lib/quill/modules/libtriggers /var/lib/quill/modules/libtriggers
cp -v ./var/lib/quill/modules/libinstall /var/lib/quill/modules/libinstall
cp -v ./var/lib/quill/modules/libprepare /var/lib/quill/modules/libprepare
cp -v ./var/lib/quill/modules/libdepends /var/lib/quill/modules/libdepends
cp -v ./var/lib/quill/modules/libdesktop /var/lib/quill/modules/libdesktop
cp -v ./var/lib/quill/modules/libfreshmeatxml /var/lib/quill/modules/libfreshmeatxml
cp -v ./var/lib/quill/modules/libpost_install /var/lib/quill/modules/libpost_install
cp -v ./var/lib/quill/ChangeLog /var/lib/quill/ChangeLog
fi

if [[ "$1" == "uninstall" ]]
then
rm -v /usr/sbin/quill
rm -v /var/lib/quill/modules/libprovides
rm -v /var/lib/quill/modules/libdetails
rm -v /var/lib/quill/modules/libconflicts
rm -v /var/lib/quill/modules/libconfigure
rm -v /var/lib/quill/modules/libfinal
rm -v /var/lib/quill/modules/libbuild
rm -v /var/lib/quill/modules/libcore
rm -v /var/lib/quill/modules/libhistory
rm -v /var/lib/quill/modules/libpre_build
rm -v /var/lib/quill/modules/libpre_install
rm -v /var/lib/quill/modules/libtriggers
rm -v /var/lib/quill/modules/libinstall
rm -v /var/lib/quill/modules/libprepare
rm -v /var/lib/quill/modules/libdepends
rm -v /var/lib/quill/modules/libdesktop
rm -v /var/lib/quill/modules/libfreshmeatxml
rm -v /var/lib/quill/modules/libpost_install
rm -v /var/lib/quill/ChangeLog
fi
