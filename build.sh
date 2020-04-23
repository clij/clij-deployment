#!/bin/bash
checkSuccess() {
  if [[ $1 -ne 0 ]]; then
    echo "==> FAILED: EXIT CODE $1"
    exit 1
  fi
}
installNewParentPom() {
  echo "== Locally install parent pom v. $1 =="
  cd ../clij-parent-pom
  git checkout tags/$1
  mvn install
}
##
# Locally install latest parent pom
##
echo "== Locally install latest parent pom =="
git clone --depth=50 --branch=master https://github.com/clij/clij-parent-pom clij-parent-pom
cd clij-parent-pom
parentpom_version=$(grep -ri "<version>" pom.xml | tail -n +2 | head -n 1 | sed -n -e 's/.*<version>\(.*\)<\/version>.*/\1/p')
echo "== Latest parent pom version is $parentpom_version"
# Keep track of parent pom versions, so we don't re-install existing ones
ppom_array+=("$parentpom_version")
echo "Array contains ${ppom_array[@]}"
mvn install
cd ..
##
# Next we need to perform the buil in the following order
#  clij-coremem
#  clij-clearcl
#  clij-core
#  clij
#  clij-ops
#  clij-custom-convolution
#  clij2
#  clijx-weka
#  clijx
##
repos="clij-coremem clij-clearcl clij-core clij clij-ops clij-custom-convolution clij2 clijx-weka clijx"
repos="clij-coremem"
#
for repo in $repos
do
  echo "== NOW BUILDING $repo =="
  git clone --depth=50 --branch=master https://github.com/clij/$repo $repo
  cd $repo
  # Check what version of the parent pom is being used
  ppom_version=$(grep -ri "<version>" pom.xml | head -n 1 | sed -n -e 's/.*<version>\(.*\)<\/version>.*/\1/p')
  if [ "$ppom_version" != "$parentpom_version" ]; then
    echo "== Uses parent pom version $ppom_version"
    if [[ "${ppom_array[@]}" =~ "${ppom_version}" ]]; then
      echo "Already installed";
    else
      echo "Need to install parent pom version $ppom_version"
      installNewParentPom $ppom_version
      ppom_array+=("$ppom_version" )
      echo "Array contains ${ppom_array[@]}"
      cd ../$repo
    fi
  fi
  echo "== $repo build =="
  mvn -Dmaven.test.skip=true install
  checkSuccess $?
  mkdir target/checkout
  echo "== $repo deploy =="
  .travis/build.sh
  checkSuccess $?
  cd ..
done
