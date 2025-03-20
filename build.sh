#!/bin/bash

# Global settings
PREFIX=$(pwd)/install
TARGET=x86_64-pc-linux-gnu
CC=afl-clang-lto
CXX=alf-clang-lto++
binutils_version=2.44

run_cmd() {
    echo "$*"

    eval "$*" || {
        echo "ERROR: $*"
        exit 1
    }
}

get_bintuils() {
    local version=$1
    run_cmd wget https://ftp.gnu.org/gnu/binutils/binutils-$version.tar.xz
    run_cmd tar -xvJf binutils-$version.tar.xz
}

configure_binutils() {
    local version=$1

    pushd binutils-$version > /dev/null

    CC=$CC CXX=$CXX ./configure --target=$TARGET --prefix=$PREFIX --disable-nls --disable-ld --disable-gdb -v

    popd > /dev/null
}

make_compile_commands() {
    local version=$1

    pushd binutils-$version > /dev/null

    popd > /dev/null

}

build_afl() {
    local version=$1

    pushd binutils-$version > /dev/null

    export LLVM_CONFIG=llvm-config 
    CC=$CC CXX=$CXX ./configure --target=$TARGET --prefix=$PREFIX --disable-nls --disable-ld --disable-gdb -v
    AFL_USE_ASAN=1 make
    AFL_USE_ASAN=1 make install

    cp $PREFIX/bin/objdump $PREFIX/bin/objdump.afl

    popd > /dev/null
}

build_cmplog() {
    local version=$1

    pushd binutils-$version > /dev/null

    export AFL_LLVM_CMPLOG=1
    export LLVM_CONFIG=llvm-config  
    make clean
    CC=$CC CXX=$CXX ./configure --target=$TARGET --prefix=$PREFIX --disable-nls --disable-ld --disable-gdb -v
    AFL_USE_ASAN=1 make
    AFL_USE_ASAN=1 make install
    unset AFL_LLVM_CMPLOG

    popd > /dev/null

    cp $PREFIX/bin/objdump $PREFIX/bin/objdump.cmplog

}

#configure_binutils $binutils_version
#make_compile_commands $binutils_version

get_bintuils $binutils_version
build_afl $binutils_version
build_cmplog $binutils_version
