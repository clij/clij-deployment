#!/bin/sh
cd clij
git clone --depth=50 --branch=master https://github.com/clij/clij tmp
mv tmp/* .
mv tmp/.* .
rmdir tmp
.travis/build.sh
cd ../clij-core
git clone --depth=50 --branch=master https://github.com/clij/clij-core tmp
mv tmp/* .
mv tmp/.* .
rmdir tmp
.travis/build.sh
cd ../clij-ops
git clone --depth=50 --branch=master https://github.com/clij/clij-ops tmp
mv tmp/* .
mv tmp/.* .
rmdir tmp
.travis/build.sh
cd ../clij-custom-convolution-plugin
git clone --depth=50 --branch=master https://github.com/clij/clij-custom-convolution-plugin tmp
mv tmp/* .
mv tmp/.* .
rmdir tmp
.travis/build.sh
cd ..
