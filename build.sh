#!/bin/sh
echo "== Locally install parent pom =="
git clone --depth=50 --branch=master https://github.com/clij/clij-parent-pom clij-parent-pom
cd clij-parent-pom
mvn install
echo "== Locally install parent pom v. 1.5.8 =="
git checkout tags/1.5.8
mvn install
cd ../clij
git clone --depth=50 --branch=master https://github.com/clij/clij tmp
mv tmp/* .
mv tmp/.* .
rmdir tmp
echo "== clij build =="
mvn -Dmaven.test.skip=true
echo "== clij deploy =="
.travis/build.sh
cd ../clij-core
git clone --depth=50 --branch=master https://github.com/clij/clij-core tmp
mv tmp/* .
mv tmp/.* .
rmdir tmp
echo "== clij-core build =="
mvn -Dmaven.test.skip=true
echo "== clij-core deploy =="
.travis/build.sh
cd ../clij-ops
git clone --depth=50 --branch=master https://github.com/clij/clij-ops tmp
mv tmp/* .
mv tmp/.* .
rmdir tmp
echo "== clij-ops build =="
mvn -Dmaven.test.skip=true
echo "== clij-ops deploy =="
.travis/build.sh
cd ../clij-custom-convolution-plugin
git clone --depth=50 --branch=master https://github.com/clij/clij-custom-convolution-plugin tmp
mv tmp/* .
mv tmp/.* .
rmdir tmp
echo "== clij-custom-convlution-plugin build =="
mvn -Dmaven.test.skip=true
echo "== clij-custom-convlution-plugin deploy =="
.travis/build.sh
cd ..
