#!/bin/bash
poulateSettingsFile() {
  settingsFile="$HOME/.m2/settings.xml"
	cat >"$settingsFile" <<EOL
<settings>
	<servers>
		<server>
			<id>scijava.releases</id>
			<username>travis</username>
			<password>\${env.MAVEN_PASS}</password>
		</server>
		<server>
			<id>scijava.snapshots</id>
			<username>travis</username>
			<password>\${env.MAVEN_PASS}</password>
		</server>
		<server>
			<id>sonatype-nexus-releases</id>
			<username>scijava-ci</username>
			<password>\${env.OSSRH_PASS}</password>
		</server>
	</servers>
EOL
  grep -A 2 '<repository>' pom.xml | grep -q 'maven.scijava.org' &&
  cat >>"$settingsFile" <<EOL
	<mirrors>
		<mirror>
			<id>scijava-mirror</id>
			<name>SciJava mirror</name>
			<url>https://maven.scijava.org/content/groups/public/</url>
			<mirrorOf>*</mirrorOf>
		</mirror>
	</mirrors>
EOL
  cat >>"$settingsFile" <<EOL
	<profiles>
		<profile>
			<id>gpg</id>
			<activation>
				<file>
					<exists>\${env.HOME}/.gnupg</exists>
				</file>
			</activation>
			<properties>
				<gpg.keyname>\${env.GPG_KEY_NAME}</gpg.keyname>
				<gpg.passphrase>\${env.GPG_PASSPHRASE}</gpg.passphrase>
			</properties>
		</profile>
	</profiles>
</settings>
EOL
}
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
echo "== Populate settings.xml file for authentication =="
poulateSettingsFile
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
echo "Installed pom(s): ${ppom_array[@]}"
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
      echo "Parent pom already installed";
    else
      echo "Need to install parent pom version $ppom_version"
      installNewParentPom $ppom_version
      ppom_array+=("$ppom_version" )
      echo "Installed pom(s): ${ppom_array[@]}"
      cd ../$repo
    fi
  fi
  echo "== $repo deploy =="
  echo "$PWD"
  ../deploy.sh $encrypted_8bc46b011822_key $encrypted_8bc46b011822_iv
  #checkSuccess $?
  cd ..
done
