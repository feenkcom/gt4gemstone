if [ -z "$GEMSTONE_WORKSPACE" ]
then
	echo "GEMSTONE_WORKSPACE must be defined"
	exit 1
fi


# Download all the required archives, git clones, etc. and upack
if [ ! -f GemStone64Bit3.7.1-x86_64.Linux.zip ]
then
	echo "Downloading GS to `pwd`"
	wget http://downloads.gemtalksystems.com/pub/GemStone64/3.7.1/GemStone64Bit3.7.1-x86_64.Linux.zip
fi

if [ ! -f GemStoneClientLibs3.7.1-x86_64.Linux.zip ]
then
	echo "Downloading GS Libs to `pwd`"
	wget http://downloads.gemtalksystems.com/pub/GemStone64/3.7.1/GemStoneClientLibs3.7.1-x86_64.Linux.zip
fi

cd ${GEMSTONE_WORKSPACE}
unzip ../GemStone64Bit3.7.1-x86_64.Linux.zip
unzip ../GemStoneClientLibs3.7.1-x86_64.Linux.zip
