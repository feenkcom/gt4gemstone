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

ARCH="$(uname -m)"
case "${ARCH}" in
    aarch64 )
        GS_SERV_FILE=GemStone64Bit${GT_GEMSTONE_ARCHIVE_VERSION}-arm64.Linux
        GS_CLIENT_FILE=GemStoneClientLibs${GT_GEMSTONE_ARCHIVE_VERSION}-arm64.Linux
        ;;
    * )
        GS_SERV_FILE="GemStone64Bit${GT_GEMSTONE_ARCHIVE_VERSION}-x86_64.Linux"
        GS_CLIENT_FILE=GemStoneClientLibs${GT_GEMSTONE_ARCHIVE_VERSION}-x86_64.Linux
        ;;
esac

# Download all the required archives, git clones, etc. and upack
if [ ! -f ${GS_SERV_FILE}.zip ]
then
    echo "Downloading GS to `pwd`"
    wget https://downloads.gemtalksystems.com/pub/GemStone64/${GT_GEMSTONE_VERSION}/${GS_SERV_FILE}.zip
fi

if [ ! -f ${GS_CLIENT_FILE}.zip ]
then
    echo "Downloading GS Libs to `pwd`"
    wget https://downloads.gemtalksystems.com/pub/GemStone64/${GT_GEMSTONE_VERSION}/${GS_CLIENT_FILE}.zip
fi

cd ${GEMSTONE_WORKSPACE}
unzip ../${GS_SERV_FILE}.zip
unzip ../${GS_CLIENT_FILE}.zip
