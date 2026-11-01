#!/bin/bash
set -euxo pipefail

./configure --prefix="$PREFIX" --sysconfdir="$PREFIX" \
    --sbindir="$PREFIX/bin" --with-munge="$PREFIX" \
    --with-mysql_config="$PREFIX/bin" || { grep -A30 -B5 'error:' config.log; exit 1; }
make -j"$CPU_COUNT"
make install
# Rebuild only the test tree for lazy daemon symbols; do not reinstall over the hardened package.
make clean
export CFLAGS="$CFLAGS -fplt"
export LDFLAGS="$LDFLAGS -Wl,-z,lazy"
make -j"$CPU_COUNT"
make check VERBOSE=1
