#!/bin/sh
git clone --depth=50 --branch=master https://github.com/clij/clij-parent-pom clij-parent-pom
cd clij-parent-pom
mvn install
git checkout tags/1.5.8
cd ../clij
git clone --depth=50 --branch=master https://github.com/clij/clij tmp
mv tmp/* .
mv tmp/.* .
rmdir tmp
mvn -Dmaven.test.skip=true
.travis/build.sh
cd ../clij-core
git clone --depth=50 --branch=master https://github.com/clij/clij-core tmp
mv tmp/* .
mv tmp/.* .
rmdir tmp
mvn -Dmaven.test.skip=true
.travis/build.sh
cd ../clij-ops
git clone --depth=50 --branch=master https://github.com/clij/clij-ops tmp
mv tmp/* .
mv tmp/.* .
rmdir tmp
mvn -Dmaven.test.skip=true
.travis/build.sh
cd ../clij-custom-convolution-plugin
git clone --depth=50 --branch=master https://github.com/clij/clij-custom-convolution-plugin tmp
mv tmp/* .
mv tmp/.* .
rmdir tmp
mvn -Dmaven.test.skip=true
.travis/build.sh
cd ..
