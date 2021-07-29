#!/bin/bash
set -e

if [ -z "$ROWAN_PROJECTS_HOME" ]
then
	echo "ROWAN_PROJECTS_HOME must be defined"
	exit 1
fi

cd $ROWAN_PROJECTS_HOME
git clone git@github.com:GemTalk/Sparkle.git
git clone git@github.com:GemTalk/RemoteServiceReplication.git
git clone git@github.com:GemTalk/SparkleFFI.git
git clone git@github.com:GemTalk/Rowan.git
git clone git@github.com:GemTalk/Announcements.git

# gtoolkit-gemstone is normally cloned manually to get this script
#git clone git@github.com:feenkcom/gtoolkit-gemstone.git

git clone git@github.com:feenkcom/gtoolkit-remote.git
