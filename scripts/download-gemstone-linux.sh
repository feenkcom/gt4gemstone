if [ -z "$GEMSTONE_WORKSPACE" ]
then
	echo "GEMSTONE_WORKSPACE must be defined"
	exit 1
fi

if [ -z "$GT_GEMSTONE_VERSION" ]
then
	echo "GT_GEMSTONE_VERSION must be defined"
	exit 1
fi

# Archive filenames omit any -BetaN suffix, but the download directory keeps it.
GT_GEMSTONE_ARCHIVE_VERSION=${GT_GEMSTONE_VERSION%-Beta*}

# Download all the required archives, git clones, etc. and upack
if [ ! -f GemStone64Bit${GT_GEMSTONE_ARCHIVE_VERSION}-x86_64.Linux.zip ]
then
	echo "Downloading GS to `pwd`"
	wget https://downloads.gemtalksystems.com/pub/GemStone64/${GT_GEMSTONE_VERSION}/GemStone64Bit${GT_GEMSTONE_ARCHIVE_VERSION}-x86_64.Linux.zip
fi

if [ ! -f GemStoneClientLibs${GT_GEMSTONE_ARCHIVE_VERSION}-x86_64.Linux.zip ]
then
	echo "Downloading GS Libs to `pwd`"
	wget https://downloads.gemtalksystems.com/pub/GemStone64/${GT_GEMSTONE_VERSION}/GemStoneClientLibs${GT_GEMSTONE_ARCHIVE_VERSION}-x86_64.Linux.zip
fi

cd ${GEMSTONE_WORKSPACE}
unzip ../GemStone64Bit${GT_GEMSTONE_ARCHIVE_VERSION}-x86_64.Linux.zip
unzip ../GemStoneClientLibs${GT_GEMSTONE_ARCHIVE_VERSION}-x86_64.Linux.zip
