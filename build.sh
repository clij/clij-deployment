#!/bin/sh
git clone --depth=50 --branch=master https://github.com/clij/clij clij
git clone --depth=50 --branch=master https://github.com/clij/clij-core clij-core
git clone --depth=50 --branch=master https://github.com/clij/clij-ops clij-ops
git clone --depth=50 --branch=master https://github.com/clij/clij-custom-convolution-plugin clij-custom-convolution-plugin
cd clij
sh ../travis-build.sh $encrypted_8bc46b011822_key $encrypted_8bc46b011822_iv
cd ../clij-core
sh ../travis-build.sh $encrypted_8bc46b011822_key $encrypted_8bc46b011822_iv
cd ../clij-ops
sh ../travis-build.sh $encrypted_8bc46b011822_key $encrypted_8bc46b011822_iv
cd ../clij-custom-convolution-plugin
sh ../travis-build.sh $encrypted_8bc46b011822_key $encrypted_8bc46b011822_iv
cd ..
