#!/bin/bash
#
# A script to build and/or release SciJava-based projects.
#
checkSuccess() {
  if [[ $1 -ne 0 ]]; then
    echo "==> FAILED: EXIT CODE $1"
    exit 1
  fi
}
if [ -f pom.xml ]
then
	export MAVEN_OPTS="$MAVEN_OPTS -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn" 
	# Import the GPG signing key.
	keyFile=signingkey.asc
	key=$1
	iv=$2
	if [ "$key" -a "$iv" -a -f "$keyFile.enc" ]
	then
		# NB: Key and iv values were given as arguments.
		echo
		echo "== Decrypting GPG keypair =="
		openssl aes-256-cbc -K "$key" -iv "$iv" -in "$keyFile.enc" -out "$keyFile" -d
		checkSuccess $?
	fi
	if [ -f "$keyFile" ]
	then
		echo
		echo "== Importing GPG keypair =="
		gpg --batch --fast-import "$keyFile"
		checkSuccess $?
	fi

	# Run the build.
	if [ "$TRAVIS_BRANCH" = master ]
	then
		echo
		echo "== Cutting and deploying release version =="
		mvn -B -Dmaven.test.skip=true -DaltReleaseDeploymentRepository=scijava.releases::default::https://maven.scijava.org/content/repositories/releases/ deploy
		checkSuccess $?
	else
		echo
		echo "== Building the artifact locally only =="
		mvn -B -Dmaven.test.skip=true install
		checkSuccess $?
	fi
fi
