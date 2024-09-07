#!/bin/bash

# Set the path to Xcode command line tools
export PATH="/Applications/Xcode.app/Contents/Developer/usr/bin:$PATH"

# Create a build directory
mkdir -p build
cd build

# Compile the dynamic library
clang -dynamiclib -o libfloatingbrowser.dylib ../floating_browser.m -framework Cocoa -framework WebKit

echo "Build complete. The library is located in build/libfloatingbrowser.dylib"
