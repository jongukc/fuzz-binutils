#!/bin/bash

# Global settings
PREFIX=$(pwd)/install
TARGET=x86_64-pc-linux-gnu
CC=afl-clang-lto
CXX=alf-clang-lto++
CFLAGS="-g -O2 --coverage"
LDFLAGS=--coverage
binutils_version=2.44

config_opt="-v \
            --disable-nls \
            --disable-ld \
            --disable-gdb \
            --disable-gprof \
            --disable-gprofng \
            --disable-doc \
            --disable-static \
            --disable-multilib \
            --disable-werror \
            --disable-nls \
            "
            
run_cmd() {
    echo "$*"

    eval "$*" || {
        echo "ERROR: $*"
        exit 1
    }
}

get_bintuils() {
    local version=$1
    local filename=binutils-$version.tar.xz
    run_cmd wget https://ftp.gnu.org/gnu/binutils/$filename
    run_cmd tar -xvJf $filename
    run_cmd rm $filename
}

configure_binutils() {
    local version=$1

    pushd binutils-$version > /dev/null

    CC=$CC CXX=$CXX CFLAGS=$CFLAGS LDFLAGS=$LDFLAGS ./configure --target=$TARGET --prefix=$PREFIX $config_opt

    popd > /dev/null
}

gen_compile_commands() {
    local version=$1

    pushd binutils-$version > /dev/null

    popd > /dev/null

}

build_afl() {
    local version=$1

    pushd binutils-$version > /dev/null

    export LLVM_CONFIG=llvm-config
    make -j$(nproc) distclean
    CC=$CC CXX=$CXX CFLAGS=$CFLAGS LDFLAGS=$LDFLAGS ./configure --target=$TARGET --prefix=$PREFIX $config_opt
    AFL_USE_ASAN=1 make -j$(nproc)
    AFL_USE_ASAN=1 make -j$(nproc) install

    cp $PREFIX/bin/objdump $PREFIX/bin/objdump.afl

    popd > /dev/null
}

build_cmplog() {
    local version=$1

    pushd binutils-$version > /dev/null

    export AFL_LLVM_CMPLOG=1
    export LLVM_CONFIG=llvm-config  
    make -j$(nproc) distclean
    CC=$CC CXX=$CXX CFLAGS=$CFLAGS LDFLAGS=$LDFLAGS ./configure --target=$TARGET --prefix=$PREFIX $config_opt
    AFL_USE_ASAN=1 make -j$(nproc)
    AFL_USE_ASAN=1 make -j$(nproc) install
    unset AFL_LLVM_CMPLOG

    popd > /dev/null

    cp $PREFIX/bin/objdump $PREFIX/bin/objdump.cmplog

}

build_lafintel() {
    local version=$1

    pushd binutils-$version > /dev/null

    export AFL_LLVM_LAF_ALL=1
    export LLVM_CONFIG=llvm-config  
    make -j$(nproc) distclean
    CC=$CC CXX=$CXX CFLAGS=$CFLAGS LDFLAGS=$LDFLAGS ./configure --target=$TARGET --prefix=$PREFIX $config_opt
    AFL_USE_ASAN=1 make -j$(nproc)
    AFL_USE_ASAN=1 make -j$(nproc) install
    unset AFL_LLVM_LAF_ALL

    popd > /dev/null

    cp $PREFIX/bin/objdump $PREFIX/bin/objdump.lafintel

}

#get_bintuils $binutils_version
#configure_binutils $binutils_version
#gen_compile_commands $binutils_version
#build_cmplog $binutils_version
#build_lafintel $binutils_version
build_afl $binutils_version
