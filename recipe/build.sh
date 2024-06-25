./configure --prefix=$PREFIX --sysconfdir=$PREFIX --with-munge=$PREFIX
make -j$CPU_COUNT
make install
make check
mv $PREFIX/sbin/* $PREFIX/bin/
