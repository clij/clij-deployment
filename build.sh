#!/bin/sh
git clone --depth=50 --branch=master https://github.com/clij/clij clij
git clone --depth=50 --branch=master https://github.com/clij/clij-core clij-core
git clone --depth=50 --branch=master https://github.com/clij/clij-ops clij-ops
git clone --depth=50 --branch=master https://github.com/clij/clij-custom-convolution-plugin clij-custom-convolution-plugin
cd clij
.travis/build.sh
cd ../clij-core
.travis/build.sh
cd ../clij-ops
.travis/build.sh
cd ../clij-custom-convolution-plugin
.travis/build.sh
cd ..
