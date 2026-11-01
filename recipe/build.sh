#!/bin/bash
set -euxo pipefail

./configure --prefix="$PREFIX" --sysconfdir="$PREFIX" \
    --sbindir="$PREFIX/bin" --with-munge="$PREFIX" \
    --with-mysql_config="$PREFIX/bin"
make -j"$CPU_COUNT"
make install
make check
