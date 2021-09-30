if [ -z "$GEMSTONE_WORKSPACE" ]
then
	echo "GEMSTONE_WORKSPACE must be defined"
	exit 1
fi

# Download all the required archives, git clones, etc. and upack
if [ ! -f GemStone64Bit3.7.0-i386.Darwin.dmg ]
then
	wget http://downloads.gemtalksystems.com/pub/GemStone64/3.7.0-Alpha2/GemStone64Bit3.7.0-i386.Darwin.dmg
fi

if [ ! -f GemStoneClientLibs3.7.0-i386.Darwin.dmg ]
then
	wget http://downloads.gemtalksystems.com/pub/GemStone64/3.7.0-Alpha2/GemStoneClientLibs3.7.0-i386.Darwin.dmg
fi

hdiutil attach GemStone64Bit3.7.0-i386.Darwin.dmg
cp -R /Volumes/installGemStone/GemStone64Bit3.7.0-i386.Darwin ${GEMSTONE_WORKSPACE}/
hdiutil detach /Volumes/installGemStone

hdiutil attach GemStoneClientLibs3.7.0-i386.Darwin.dmg
cp -R /Volumes/GemStoneClientLibs3.7.0-i386.Darwin/3.7.0 ${GEMSTONE_WORKSPACE}/
hdiutil detach /Volumes/GemStoneClientLibs3.7.0-i386.Darwin