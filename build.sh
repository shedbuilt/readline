#!/bin/bash
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/readline-7.0
make -j $SHED_NUMJOBS SHLIB_LIBS="-lncursesw"
make DESTDIR=$SHED_FAKEROOT SHLIB_LIBS="-lncurses" install
mkdir -pv ${SHED_FAKEROOT}/lib
mv -v ${SHED_FAKEROOT}/usr/lib/lib{readline,history}.so.* ${SHED_FAKEROOT}/lib
ln -sfv ../../lib/$(readlink ${SHED_FAKEROOT}/usr/lib/libreadline.so) ${SHED_FAKEROOT}/usr/lib/libreadline.so
ln -sfv ../../lib/$(readlink ${SHED_FAKEROOT}/usr/lib/libhistory.so ) ${SHED_FAKEROOT}/usr/lib/libhistory.so
install -v -Dm644 doc/*.{ps,pdf,html,dvi} ${SHED_FAKEROOT}/usr/share/doc/readline-7.0
