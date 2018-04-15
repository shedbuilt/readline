#!/bin/bash
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/readline-7.0 || exit 1
if [ "$SHED_BUILD_MODE" == 'bootstrap' ]; then
    READLINE_BUILD_LIBS="-L/tools/lib -lncursesw"
    READLINE_INSTALL_LIBS="-L/tools/lib -lncurses"
else
    READLINE_BUILD_LIBS="-lncursesw"
    READLINE_INSTALL_LIBS="-lncurses"
fi
make -j $SHED_NUM_JOBS SHLIB_LIBS="$READLINE_BUILD_LIBS" || exit 1
make DESTDIR="$SHED_FAKE_ROOT" SHLIB_LIBS="$READLINE_INSTALL_LIBS" install || exit 1
mkdir -pv ${SHED_FAKE_ROOT}/lib
mv -v ${SHED_FAKE_ROOT}/usr/lib/lib{readline,history}.so.* ${SHED_FAKE_ROOT}/lib
# Make the libraries writable so we can strip them
chmod 755 ${SHED_FAKE_ROOT}/lib/lib{readline,history}.so.*
ln -sfv ../../lib/$(readlink ${SHED_FAKE_ROOT}/usr/lib/libreadline.so) ${SHED_FAKE_ROOT}/usr/lib/libreadline.so
ln -sfv ../../lib/$(readlink ${SHED_FAKE_ROOT}/usr/lib/libhistory.so ) ${SHED_FAKE_ROOT}/usr/lib/libhistory.so
install -v -Dm644 doc/*.{ps,pdf,html,dvi} ${SHED_FAKE_ROOT}/usr/share/doc/readline-7.0
