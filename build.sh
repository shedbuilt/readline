#!/bin/bash
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/readline-7.0 || exit 1
if [ "$SHED_BUILDMODE" == 'bootstrap' ]; then
    READLINE_BUILD_LIBS="-L/tools/lib -lncursesw"
    READLINE_INSTALL_LIBS="-L/tools/lib -lncurses"
else
    READLINE_BUILD_LIBS="-lncursesw"
    READLINE_INSTALL_LIBS="-lncurses"
fi
make -j $SHED_NUMJOBS SHLIB_LIBS="$READLINE_BUILD_LIBS" || exit 1
make DESTDIR="$SHED_FAKEROOT" SHLIB_LIBS="$READLINE_INSTALL_LIBS" install || exit 1
mkdir -pv ${SHED_FAKEROOT}/lib
mv -v ${SHED_FAKEROOT}/usr/lib/lib{readline,history}.so.* ${SHED_FAKEROOT}/lib
# Make the libraries writable so we can strip them
chmod 755 ${SHED_FAKEROOT}/lib/lib{readline,history}.so.*
ln -sfv ../../lib/$(readlink ${SHED_FAKEROOT}/usr/lib/libreadline.so) ${SHED_FAKEROOT}/usr/lib/libreadline.so
ln -sfv ../../lib/$(readlink ${SHED_FAKEROOT}/usr/lib/libhistory.so ) ${SHED_FAKEROOT}/usr/lib/libhistory.so
install -v -Dm644 doc/*.{ps,pdf,html,dvi} ${SHED_FAKEROOT}/usr/share/doc/readline-7.0
