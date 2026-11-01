#!/bin/bash
set -euxo pipefail

./configure --prefix="$PREFIX" --sysconfdir="$PREFIX" \
    --sbindir="$PREFIX/bin" --with-munge="$PREFIX" \
    --with-mysql_config="$PREFIX/bin" || { grep -A30 -B5 'error:' config.log; exit 1; }
make -j"$CPU_COUNT"
make install
# Test harnesses intentionally leave unused daemon symbols unresolved; installed binaries keep hardening.
make check VERBOSE=1 CFLAGS="$CFLAGS -fplt" LDFLAGS="$LDFLAGS -Wl,-z,lazy"
