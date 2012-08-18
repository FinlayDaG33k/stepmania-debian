#!/bin/bash
set -e

test -e ProductInfo.h && cd ..
if ! test -d src; then
	echo Run this script from the top directory.
	exit 1
fi

source Utils/GetProductVer.sh src/ProductInfo.h
PRODUCTVER="$PRODUCTVER-src"

if test -e $PRODUCTVER; then
	echo "\"$PRODUCTVER\" already exists."
	exit 1
fi
echo Copying...

mkdir $PRODUCTVER
cp -dpR autoconf $PRODUCTVER/
#cp -dpR Utils $PRODUCTVER/
cp -dpR src $PRODUCTVER/

cp Docs/Copying.MAD Docs/Licenses.txt Docs/Changelog_sm5.txt \
   Docs/Changelog_sm-ssc.txt Docs/Changelog_SSCformat.txt \
   Docs/credits.txt Docs/KnownIssues.txt \
   Docs/license-ext/readme Docs/license-ext/Scoring-jp.txt \
   Docs/license-ext/theme_lang-ja.txt Docs/vlgothic/Changelog \
   Docs/license-ext/vlgothic/LICENSE Docs/license-ext/vlgothic/LICENSE.en\
   Docs/license-ext/vlgothic/LICENSE_E.mplus Docs/license-ext/vlgothic/LICENSE_J.mplus \
   Docs/license-ext/vlgothic/README Docs/license-ext/vlgothic/README.sazanami \
   Docs/license-ext/vlgothic/README_J.mplus \
   Makefile.am aclocal.m4 configure Makefile.in configure.ac \
   $PRODUCTVER

echo Pruning...
cd $PRODUCTVER/src
# Incomplete:
rm -rf Texture Font Generator
# Unused:
rm -rf smlobby

# Windows-only stuff.  Let's leave some in the archive to make the GPL happy.
# I don't want to spend an extra half hour to upload separate Windows and
# *nix source archives.
#rm -rf mad-0.15.0b

rm -rf lua-5.1
rm -rf vorbis
rm -rf BaseClasses
rm -rf ddk
rm -rf smpackage

cd ..

find . -type d -name 'CVS' | xargs rm -rf
find . -type d -name '.svn' | xargs rm -rf
find . -type f -name '*.lib' | xargs rm -rf
find . -type f -name '*.exe' | xargs rm -rf
find . -type f -name '*.a' | xargs rm -rf
find . -type f -name '*.o' | xargs rm -rf
find . -type f -name '.hg*' | xargs rm -rf

cd ..
#rm -rf Utils/Font\ generation/

echo Archiving...
tar zchvf "$PRODUCTVER".tar.gz $PRODUCTVER/

