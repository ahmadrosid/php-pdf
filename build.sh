#!/bin/bash
set -e

if [[ "$1" == "--release" ]]; then
    echo "Build release";
    cargo build --release
    file=target/release/libphp_pdf.so
    [ -f ./file ] && rm $file
    cp target/release/libphp_pdf.dylib target/release/libphp_pdf.so
    # See your php.ini please
    release_file=/opt/homebrew/lib/php/pecl/20210902/libphp_pdf.so
    [ -f ./release_file ] && rm $release_file
    cp target/release/libphp_pdf.so /opt/homebrew/lib/php/pecl/20210902/
    ls /opt/homebrew/lib/php/pecl/20210902/
else
    cargo build
    file=target/debug/libphp_pdf.so
    [ -f ./file ] && rm $file
    cp target/debug/libphp_pdf.dylib target/debug/libphp_pdf.so
fi
