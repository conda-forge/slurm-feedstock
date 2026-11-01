#!/bin/bash
set -euxo pipefail

./configure --prefix="$PREFIX" --sysconfdir="$PREFIX" \
    --sbindir="$PREFIX/bin" --with-munge="$PREFIX" \
    --with-json="$PREFIX" --with-yaml="$PREFIX" \
    --with-mysql_config="$PREFIX/bin" || { grep -A30 -B5 'error:' config.log; exit 1; }
make -j"$CPU_COUNT"
make install
# Rebuild only the test tree for lazy daemon symbols; do not reinstall over the hardened package.
make clean
make -j"$CPU_COUNT" CFLAGS="$CFLAGS -fplt" LDFLAGS="$LDFLAGS -Wl,-z,lazy"
make check VERBOSE=1 CFLAGS="$CFLAGS -fplt" LDFLAGS="$LDFLAGS -Wl,-z,lazy"
"$READELF" -d "$PREFIX/bin/slurmctld" | grep BIND_NOW
