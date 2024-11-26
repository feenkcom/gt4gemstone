if [ -z "$GEMSTONE_WORKSPACE" ]
then
	echo "GEMSTONE_WORKSPACE must be defined"
	exit 1
fi

ARCH="$(uname -m)"
case "${ARCH}" in
    arm64 ) 
		GS_SERV_FILE=GemStone64Bit3.7.1-arm64.Darwin
		GS_CLIENT_FILE=GemStoneClientLibs3.7.1-arm64.Darwin
		;;
    * ) 
		GS_SERV_FILE="GemStone64Bit3.7.1-i386.Darwin"
		GS_CLIENT_FILE=GemStoneClientLibs3.7.1-i386.Darwin
		;;
esac

# Download all the required archives, git clones, etc. and upack
if [ ! -f "${GS_CLIENT_FILE}".dmg ]
then
	wget http://downloads.gemtalksystems.com/pub/GemStone64/3.7.1/"$GS_SERV_FILE".dmg
fi

if [ ! -f "${GS_CLIENT_FILE}".dmg ]
then
	wget http://downloads.gemtalksystems.com/pub/GemStone64/3.7.1/"${GS_CLIENT_FILE}".dmg
fi

hdiutil attach "${GS_SERV_FILE}".dmg
cp -R /Volumes/installGemStone/"${GS_SERV_FILE}" "${GEMSTONE_WORKSPACE}/"
hdiutil detach /Volumes/installGemStone

hdiutil attach "${GS_CLIENT_FILE}".dmg
cp -R /Volumes/"${GS_CLIENT_FILE}"/3.7.1 "${GEMSTONE_WORKSPACE}/"
hdiutil detach /Volumes/"${GS_CLIENT_FILE}"
