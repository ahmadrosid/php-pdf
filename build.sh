#!/bin/bash
set -e
cargo build
file=target/debug/libphp_pdf.so
[ -f ./file ] && rm $file
cp target/debug/libphp_pdf.dylib target/debug/libphp_pdf.so