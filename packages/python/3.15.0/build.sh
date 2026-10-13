#!/bin/bash
set -eu -o pipefail

PREFIX="$(realpath "$(dirname "$0")")"

mkdir -p build
cd build

curl "https://www.python.org/ftp/python/3.15.0/Python-3.15.0.tgz" \
    | tar xz --strip-components=1

./configure --prefix "$PREFIX" --with-ensurepip=install \
    --enable-optimizations --with-lto \
    --disable-test-modules --without-static-libpython
make -j"$(nproc)"
make install -j"$(nproc)"

cd ..
rm -rf build

bin/pip3 install numpy scipy pandas pycryptodome whoosh \
    bcrypt passlib sympy xxhash base58 cryptography PyNaCl \
    yabi-bython==0.10.0
