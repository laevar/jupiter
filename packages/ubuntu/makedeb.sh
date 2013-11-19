#!/bin/bash
copy="rsync -av"
builddir=jupiter
mkdir $builddir
mkdir $builddir/etc/
$copy DEBIAN $builddir/
$copy ../../jupiter-current/ $builddir/
dpkg-deb --build $builddir
rm -rf $builddir
